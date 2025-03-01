// src/client/utils/index.ts
var ped = 0;
var updatePed = (pedHandle) => {
  ped = pedHandle;
};
var sendNUIEvent = (action, data) => {
  SendNUIMessage({
    action,
    data
  });
};
var delay = (ms) => new Promise((res) => setTimeout(res, ms));
var requestModel = async (model) => {
  let modelHash = typeof model === "number" ? model : GetHashKey(model);
  if (!IsModelValid(modelHash) && !IsModelInCdimage(modelHash)) {
    console.warn(`attempted to load invalid model '${model}'`);
    return 0;
  }
  if (HasModelLoaded(modelHash))
    return modelHash;
  RequestModel(modelHash);
  const waitForModelLoaded = () => {
    return new Promise((resolve) => {
      const interval = setInterval(() => {
        if (HasModelLoaded(modelHash)) {
          clearInterval(interval);
          resolve();
        }
      }, 100);
    });
  };
  await waitForModelLoaded();
  return modelHash;
};
var resourceName = GetCurrentResourceName();
var eventTimers = {};
var activeEvents = {};
function eventTimer(eventName, delay3) {
  if (delay3 && delay3 > 0) {
    const currentTime = GetGameTimer();
    if ((eventTimers[eventName] || 0) > currentTime)
      return false;
    eventTimers[eventName] = currentTime + delay3;
  }
  return true;
}
onNet(`_bl_cb_${resourceName}`, (key, ...args) => {
  const resolve = activeEvents[key];
  return resolve && resolve(...args);
});
function triggerServerCallback(eventName, ...args) {
  if (!eventTimer(eventName, 0)) {
    return;
  }
  let key;
  do {
    key = `${eventName}:${Math.floor(Math.random() * (1e5 + 1))}`;
  } while (activeEvents[key]);
  emitNet(`_bl_cb_${eventName}`, resourceName, key, ...args);
  return new Promise((resolve) => {
    activeEvents[key] = resolve;
  });
}
function onServerCallback(eventName, cb) {
  onNet(`_bl_cb_${eventName}`, async (resource, key, ...args) => {
    let response;
    try {
      response = await cb(...args);
    } catch (e) {
      console.error(`an error occurred while handling callback event ${eventName}`);
      console.log(`^3${e.stack}^0`);
    }
    emitNet(`_bl_cb_${resource}`, key, response);
  });
}
var requestLocale = (resourceSetName) => {
  return new Promise((resolve) => {
    const checkResourceFile = () => {
      if (RequestResourceFileSet(resourceSetName)) {
        const currentLan = exports.bl_appearance.config().locale;
        let localeFileContent = LoadResourceFile(resourceName, `locale/${currentLan}.json`);
        if (!localeFileContent) {
          console.error(`${currentLan}.json not found in locale, please verify!, we used english for now!`);
          localeFileContent = LoadResourceFile(resourceName, `locale/en.json`);
        }
        resolve(localeFileContent);
      } else {
        setTimeout(checkResourceFile, 100);
      }
    };
    checkResourceFile();
  });
};
var bl_bridge = exports.bl_bridge;
var getPlayerData = () => {
  return bl_bridge.core().getPlayerData();
};
var getFrameworkID = () => {
  const id = getPlayerData().cid;
  return id;
};
var getPlayerGenderModel = () => {
  const gender = getPlayerData().gender;
  return gender === "male" ? "mp_m_freemode_01" : "mp_f_freemode_01";
};
function Delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
function format(str) {
  if (!str.includes("'"))
    return str;
  return str.replace(/'/g, "");
}
function getJobInfo() {
  const job = getPlayerData().job;
  return job ? { name: job.name, isBoss: job.isBoss } : null;
}
function isPedFreemodeModel(ped3) {
  const model = GetEntityModel(ped3);
  return model === GetHashKey("mp_m_freemode_01") || model === GetHashKey("mp_f_freemode_01");
}

// src/client/camera.ts
var WHOLE_BODY_MAX_DISTANCE = 2;
var DEFAULT_MAX_DISTANCE = 1;
var running = false;
var camDistance = 1.8;
var cam = null;
var angleY = 0;
var angleZ = 0;
var targetCoords = null;
var oldCam = null;
var changingCam = false;
var currentBone = "head";
var CameraBones = {
  whole: 0,
  head: 31086,
  torso: 24818,
  legs: [16335, 46078],
  shoes: [14201, 52301]
};
var cos = (degrees) => {
  return Math.cos(degrees * Math.PI / 180);
};
var sin = (degrees) => {
  return Math.sin(degrees * Math.PI / 180);
};
var getAngles = () => {
  const x = (cos(angleZ) * cos(angleY) + cos(angleY) * cos(angleZ)) / 2 * camDistance;
  const y = (sin(angleZ) * cos(angleY) + cos(angleY) * sin(angleZ)) / 2 * camDistance;
  const z = sin(angleY) * camDistance;
  return [x, y, z];
};
var setCamPosition = (mouseX, mouseY) => {
  if (!running || !targetCoords || changingCam)
    return;
  mouseX = mouseX ?? 0;
  mouseY = mouseY ?? 0;
  angleZ -= mouseX;
  angleY += mouseY;
  const isHeadOrWhole = currentBone === "whole" || currentBone === "head";
  const maxAngle = isHeadOrWhole ? 89 : 70;
  const isShoes = currentBone === "shoes";
  const minAngle = isShoes ? 5 : -20;
  angleY = Math.min(Math.max(angleY, minAngle), maxAngle);
  const [x, y, z] = getAngles();
  SetCamCoord(
    cam,
    targetCoords.x + x,
    targetCoords.y + y,
    targetCoords.z + z
  );
  PointCamAtCoord(cam, targetCoords.x, targetCoords.y, targetCoords.z);
};
var moveCamera = async (coords, distance) => {
  const heading = GetEntityHeading(ped) + 94;
  distance = distance ?? 1;
  changingCam = true;
  camDistance = distance;
  angleZ = heading;
  const [x, y, z] = getAngles();
  const newcam = CreateCamWithParams(
    "DEFAULT_SCRIPTED_CAMERA",
    coords.x + x,
    coords.y + y,
    coords.z + z,
    0,
    0,
    0,
    70,
    false,
    0
  );
  targetCoords = coords;
  changingCam = false;
  oldCam = cam;
  cam = newcam;
  PointCamAtCoord(newcam, coords.x, coords.y, coords.z);
  SetCamActiveWithInterp(newcam, oldCam, 250, 0, 0);
  await delay(250);
  SetCamUseShallowDofMode(newcam, true);
  SetCamNearDof(newcam, 0.4);
  SetCamFarDof(newcam, 1.2);
  SetCamDofStrength(newcam, 0.3);
  useHiDof(newcam);
  DestroyCam(oldCam, true);
};
var useHiDof = (currentcam) => {
  if (!(DoesCamExist(cam) && currentcam == cam))
    return;
  SetUseHiDof();
  setTimeout(useHiDof, 0);
};
var startCamera = () => {
  if (running)
    return;
  running = true;
  camDistance = WHOLE_BODY_MAX_DISTANCE;
  cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true);
  const [x, y, z] = GetPedBoneCoords(ped, 31086, 0, 0, 0);
  SetCamCoord(cam, x, y, z);
  RenderScriptCams(true, true, 1e3, true, true);
  setCamera("whole", camDistance);
};
var stopCamera = () => {
  if (!running)
    return;
  running = false;
  RenderScriptCams(false, true, 250, true, false);
  DestroyCam(cam, true);
  cam = null;
  targetCoords = null;
};
var setCamera = (type, distance = camDistance) => {
  const bone = CameraBones[type];
  const isBoneArray = Array.isArray(bone);
  currentBone = type;
  if (!isBoneArray && bone === 0) {
    const [x2, y2, z2] = GetEntityCoords(ped, false);
    moveCamera(
      {
        x: x2,
        y: y2,
        z: z2 + 0
      },
      distance
    );
    return;
  }
  if (distance > DEFAULT_MAX_DISTANCE)
    distance = DEFAULT_MAX_DISTANCE;
  if (isBoneArray) {
    const [x1, y1, z1] = GetPedBoneCoords(ped, bone[0], 0, 0, 0);
    const [x2, y2, z2] = GetPedBoneCoords(ped, bone[1], 0, 0, 0);
    var x = (x1 + x2) / 2;
    var y = (y1 + y2) / 2;
    var z = (z1 + z2) / 2;
  } else {
    var [x, y, z] = GetPedBoneCoords(ped, bone, 0, 0, 0);
  }
  moveCamera(
    {
      x,
      y,
      z: z + 0
    },
    distance
  );
};
RegisterNuiCallback("appearance:camMove" /* camMove */, (data, cb) => {
  setCamPosition(data.x, data.y);
  cb(1);
});
RegisterNuiCallback("appearance:camSection" /* camSection */, (type, cb) => {
  switch (type) {
    case "whole":
      setCamera("whole", WHOLE_BODY_MAX_DISTANCE);
      break;
    case "head":
      setCamera("head");
      break;
    case "torso":
      setCamera("torso");
      break;
    case "legs":
      setCamera("legs");
      break;
    case "shoes":
      setCamera("shoes");
      setCamPosition();
      break;
  }
  cb(1);
});
RegisterNuiCallback("appearance:camZoom" /* camZoom */, (data, cb) => {
  if (data === "down") {
    const maxZoom = currentBone === "whole" ? WHOLE_BODY_MAX_DISTANCE : DEFAULT_MAX_DISTANCE;
    const newDistance = camDistance + 0.05;
    camDistance = newDistance >= maxZoom ? maxZoom : newDistance;
  } else if (data === "up") {
    const newDistance = camDistance - 0.05;
    camDistance = newDistance <= 0.3 ? 0.3 : newDistance;
  }
  camDistance = camDistance;
  setCamPosition();
  cb(1);
});

// src/data/head.ts
var head_default = [
  "Blemishes",
  "FacialHair",
  "Eyebrows",
  "Ageing",
  "Makeup",
  "Blush",
  "Complexion",
  "SunDamage",
  "Lipstick",
  "MolesFreckles",
  "ChestHair",
  "BodyBlemishes",
  "AddBodyBlemishes",
  "EyeColor"
];

// src/data/face.ts
var face_default = [
  "Nose_Width",
  "Nose_Peak_Height",
  "Nose_Peak_Lenght",
  "Nose_Bone_Height",
  "Nose_Peak_Lowering",
  "Nose_Bone_Twist",
  "EyeBrown_Height",
  "EyeBrown_Forward",
  "Cheeks_Bone_High",
  "Cheeks_Bone_Width",
  "Cheeks_Width",
  "Eyes_Openning",
  "Lips_Thickness",
  "Jaw_Bone_Width",
  "Jaw_Bone_Back_Lenght",
  "Chin_Bone_Lowering",
  "Chin_Bone_Length",
  "Chin_Bone_Width",
  "Chin_Hole",
  "Neck_Thikness"
];

// src/data/drawables.ts
var drawables_default = [
  "face",
  "masks",
  "hair",
  "torsos",
  "legs",
  "bags",
  "shoes",
  "neck",
  "shirts",
  "vest",
  "decals",
  "jackets"
];

// src/data/props.ts
var props_default = [
  "hats",
  "glasses",
  "earrings",
  "mouth",
  "lhand",
  "rhand",
  "watches",
  "bracelets"
];

// src/client/appearance/getters.ts
function findModelIndex(target) {
  const config2 = exports.bl_appearance;
  const models = config2.models();
  return models.findIndex((model) => GetHashKey(model) === target);
}
function getHairColor(pedHandle) {
  return {
    color: GetPedHairColor(pedHandle),
    highlight: GetPedHairHighlightColor(pedHandle)
  };
}
exports("GetPedHairColor", getHairColor);
function getHeadBlendData(pedHandle) {
  const buffer = new ArrayBuffer(80);
  global.Citizen.invokeNative("0x2746bd9d88c5c5d0", pedHandle, new Uint32Array(buffer));
  const { 0: shapeFirst, 2: shapeSecond, 4: shapeThird, 6: skinFirst, 8: skinSecond, 18: hasParent, 10: skinThird } = new Uint32Array(buffer);
  const { 0: shapeMix, 2: skinMix, 4: thirdMix } = new Float32Array(buffer, 48);
  return {
    shapeFirst,
    // father
    shapeSecond,
    // mother
    shapeThird,
    skinFirst,
    skinSecond,
    skinThird,
    shapeMix,
    // resemblance
    thirdMix,
    skinMix,
    // skinpercent
    hasParent: Boolean(hasParent)
  };
}
exports("GetPedHeadBlend", getHeadBlendData);
function getHeadOverlay(pedHandle) {
  let totals = {};
  let headData = {};
  for (let i = 0; i < head_default.length; i++) {
    const overlay = head_default[i];
    totals[overlay] = GetNumHeadOverlayValues(i);
    if (overlay === "EyeColor") {
      headData[overlay] = {
        index: i,
        overlayValue: GetPedEyeColor(pedHandle)
      };
    } else {
      const [_, overlayValue, colourType, firstColor, secondColor, overlayOpacity] = GetPedHeadOverlayData(pedHandle, i);
      headData[overlay] = {
        index: i,
        overlayValue: overlayValue === 255 ? -1 : overlayValue,
        colourType,
        firstColor,
        secondColor,
        overlayOpacity
      };
    }
  }
  return [headData, totals];
}
exports("GetPedHeadOverlay", getHeadOverlay);
function getHeadStructure(pedHandle) {
  const pedModel = GetEntityModel(pedHandle);
  if (pedModel !== GetHashKey("mp_m_freemode_01") && pedModel !== GetHashKey("mp_f_freemode_01"))
    return;
  let faceStruct = {};
  for (let i = 0; i < face_default.length; i++) {
    const overlay = face_default[i];
    faceStruct[overlay] = {
      id: overlay,
      index: i,
      value: GetPedFaceFeature(pedHandle, i)
    };
  }
  return faceStruct;
}
exports("GetPedHeadStructure", getHeadStructure);
function getDrawables(pedHandle) {
  let drawables = {};
  let totalDrawables = {};
  for (let i = 0; i < drawables_default.length; i++) {
    const name = drawables_default[i];
    const current = GetPedDrawableVariation(pedHandle, i);
    totalDrawables[name] = {
      id: name,
      index: i,
      total: GetNumberOfPedDrawableVariations(pedHandle, i),
      textures: GetNumberOfPedTextureVariations(pedHandle, i, current)
    };
    drawables[name] = {
      id: name,
      index: i,
      value: GetPedDrawableVariation(pedHandle, i),
      texture: GetPedTextureVariation(pedHandle, i)
    };
  }
  return [drawables, totalDrawables];
}
exports("GetPedDrawables", getDrawables);
function getProps(pedHandle) {
  let props = {};
  let totalProps = {};
  for (let i = 0; i < props_default.length; i++) {
    const name = props_default[i];
    const current = GetPedPropIndex(pedHandle, i);
    totalProps[name] = {
      id: name,
      index: i,
      total: GetNumberOfPedPropDrawableVariations(pedHandle, i),
      textures: GetNumberOfPedPropTextureVariations(pedHandle, i, current)
    };
    props[name] = {
      id: name,
      index: i,
      value: GetPedPropIndex(pedHandle, i),
      texture: GetPedPropTextureIndex(pedHandle, i)
    };
  }
  return [props, totalProps];
}
exports("GetPedProps", getProps);
async function getAppearance(pedHandle) {
  const [headData, totals] = getHeadOverlay(pedHandle);
  const [drawables, drawTotal] = getDrawables(pedHandle);
  const [props, propTotal] = getProps(pedHandle);
  const model = GetEntityModel(pedHandle);
  const tattoos = pedHandle == PlayerPedId() ? await getTattoos() : [];
  return {
    modelIndex: findModelIndex(model),
    model,
    hairColor: getHairColor(pedHandle),
    headBlend: getHeadBlendData(pedHandle),
    headOverlay: headData,
    headOverlayTotal: totals,
    headStructure: getHeadStructure(pedHandle),
    drawables,
    props,
    drawTotal,
    propTotal,
    tattoos
  };
}
exports("GetPedAppearance", getAppearance);
onServerCallback("bl_appearance:client:getAppearance", () => {
  updatePed(PlayerPedId());
  return getAppearance(ped);
});
function getPedClothes(pedHandle) {
  const [drawables] = getDrawables(pedHandle);
  const [props] = getProps(pedHandle);
  const [headData] = getHeadOverlay(pedHandle);
  return {
    headOverlay: headData,
    drawables,
    props
  };
}
exports("GetPedClothes", getPedClothes);
function getPedSkin(pedHandle) {
  return {
    headBlend: getHeadBlendData(pedHandle),
    headStructure: getHeadStructure(pedHandle),
    hairColor: getHairColor(pedHandle),
    model: GetEntityModel(pedHandle)
  };
}
exports("GetPedSkin", getPedSkin);
function getTattooData() {
  let tattooZones = [];
  const [TATTOO_LIST, TATTOO_CATEGORIES] = exports.bl_appearance.tattoos();
  for (let i = 0; i < TATTOO_CATEGORIES.length; i++) {
    const category = TATTOO_CATEGORIES[i];
    const zone = category.zone;
    const label = category.label;
    const index = category.index;
    tattooZones[index] = {
      zone,
      label,
      zoneIndex: index,
      dlcs: []
    };
    for (let j = 0; j < TATTOO_LIST.length; j++) {
      const dlcData = TATTOO_LIST[j];
      tattooZones[index].dlcs.push({
        label: dlcData.dlc,
        dlcIndex: j,
        tattoos: []
      });
    }
  }
  const isFemale = GetEntityModel(ped) === GetHashKey("mp_f_freemode_01");
  for (let i = 0; i < TATTOO_LIST.length; i++) {
    const data = TATTOO_LIST[i];
    const { dlc, tattoos } = data;
    const dlcHash = GetHashKey(dlc);
    for (let j = 0; j < tattoos.length; j++) {
      const tattooData = tattoos[j];
      let tattoo = null;
      const lowerTattoo = tattooData.toLowerCase();
      const isFemaleTattoo = lowerTattoo.includes("_f");
      if (isFemaleTattoo && isFemale) {
        tattoo = tattooData;
      } else if (!isFemaleTattoo && !isFemale) {
        tattoo = tattooData;
      }
      let hash = null;
      let zone = -1;
      if (tattoo) {
        hash = GetHashKey(tattoo);
        zone = GetPedDecorationZoneFromHashes(dlcHash, hash);
      }
      if (zone !== -1 && hash) {
        const zoneTattoos = tattooZones[zone].dlcs[i].tattoos;
        zoneTattoos.push({
          label: tattoo,
          hash,
          zone,
          dlc
        });
      }
    }
  }
  return tattooZones;
}
async function getTattoos() {
  return await triggerServerCallback("bl_appearance:server:getTattoos") || [];
}
exports("GetPlayerTattoos", getTattoos);
onServerCallback("bl_appearance:client:migration:setAppearance", (data) => {
  if (data.type === "fivem")
    exports["fivem-appearance"].setPlayerAppearance(data.data);
  if (data.type === "illenium")
    exports["illenium-appearance"].setPlayerAppearance(data.data);
});

// src/data/toggles.ts
var toggles_default = {
  hats: {
    type: "prop",
    index: 0
  },
  glasses: {
    type: "prop",
    index: 1
  },
  masks: {
    type: "drawable",
    index: 1,
    off: 0
  },
  shirts: {
    type: "drawable",
    index: 8,
    off: 15,
    hook: {
      drawables: [
        { component: 3, variant: 15, texture: 0, id: "torsos" },
        { component: 8, variant: 15, texture: 0, id: "shirts" }
      ]
    }
  },
  jackets: {
    type: "drawable",
    index: 11,
    off: 15,
    hook: {
      drawables: [
        { component: 3, variant: 15, texture: 0, id: "torsos" },
        { component: 11, variant: 15, texture: 0, id: "jackets" }
      ]
    }
  },
  vest: {
    type: "drawable",
    index: 9,
    off: 0
  },
  legs: {
    type: "drawable",
    index: 4,
    off: 18
  },
  shoes: {
    type: "drawable",
    index: 6,
    off: 34
  }
};

// src/client/appearance/setters.ts
function setDrawable(pedHandle, data) {
  if (!data)
    return console.warn("No data provided for setDrawable");
  SetPedComponentVariation(pedHandle, data.index, data.value, data.texture, 0);
  return GetNumberOfPedTextureVariations(pedHandle, data.index, data.value);
}
exports("SetPedDrawable", setDrawable);
function setProp(pedHandle, data) {
  if (!data)
    return console.warn("No data provided for setProp");
  if (data.value === -1) {
    ClearPedProp(pedHandle, data.index);
    return;
  }
  SetPedPropIndex(pedHandle, data.index, data.value, data.texture, false);
  return GetNumberOfPedPropTextureVariations(pedHandle, data.index, data.value);
}
exports("SetPedProp", setProp);
var defMaleHash = GetHashKey("mp_m_freemode_01");
var setModel = async (pedHandle, data) => {
  if (data == null || data === void 0) {
    console.warn("No data provided for setModel");
    return pedHandle;
  }
  let model;
  if (typeof data === "string") {
    model = GetHashKey(data);
  } else if (typeof data === "number") {
    model = data;
  } else {
    model = data.model || defMaleHash;
  }
  if (model === 0)
    return pedHandle;
  await requestModel(model);
  const isPlayer = IsPedAPlayer(pedHandle);
  if (isPlayer) {
    SetPlayerModel(PlayerId(), model);
    pedHandle = PlayerPedId();
    updatePed(pedHandle);
  } else {
    SetPlayerModel(pedHandle, model);
  }
  SetModelAsNoLongerNeeded(model);
  SetPedDefaultComponentVariation(pedHandle);
  if (!isPedFreemodeModel(pedHandle))
    return pedHandle;
  const isJustModel = typeof data === "string" || typeof data === "number";
  const hasHeadBlend = !isJustModel && data.headBlend && Object.keys(data.headBlend).length > 0;
  if (hasHeadBlend) {
    setHeadBlend(pedHandle, data.headBlend);
    SetPedHeadBlendData(pedHandle, 0, 0, 0, 0, 0, 0, 0, 0, 0, false);
  } else {
    if (model === GetHashKey("mp_m_freemode_01")) {
      SetPedHeadBlendData(pedHandle, 0, 0, 0, 0, 0, 0, 0, 0, 0, false);
    } else if (model === GetHashKey("mp_f_freemode_01")) {
      SetPedHeadBlendData(pedHandle, 45, 21, 0, 20, 15, 0, 0.3, 0.1, 0, false);
    }
  }
  return pedHandle;
};
exports("SetPedModel", setModel);
function setFaceFeature(pedHandle, data) {
  if (!data)
    return console.warn("No data provided for setFaceFeature");
  SetPedFaceFeature(pedHandle, data.index, data.value + 0);
}
exports("SetPedFaceFeature", setFaceFeature);
function setFaceFeatures(pedHandle, data) {
  if (!data)
    return console.warn("No data provided for setFaceFeatures");
  for (const feature in data) {
    const value = data[feature];
    setFaceFeature(pedHandle, value);
  }
}
exports("SetPedFaceFeatures", setFaceFeatures);
var isPositive = (val) => val >= 0 ? val : 0;
function setHeadBlend(pedHandle, data) {
  if (!data)
    return console.warn("No data provided for setHeadBlend");
  pedHandle = pedHandle || ped;
  if (!isPedFreemodeModel(pedHandle))
    return;
  const shapeFirst = isPositive(data.shapeFirst);
  const shapeSecond = isPositive(data.shapeSecond);
  const shapeThird = isPositive(data.shapeThird);
  const skinFirst = isPositive(data.skinFirst);
  const skinSecond = isPositive(data.skinSecond);
  const skinThird = isPositive(data.skinThird);
  const shapeMix = data.shapeMix + 0;
  const skinMix = data.skinMix + 0;
  const thirdMix = data.thirdMix + 0;
  const hasParent = data.hasParent;
  SetPedHeadBlendData(pedHandle, shapeFirst, shapeSecond, shapeThird, skinFirst, skinSecond, skinThird, shapeMix, skinMix, thirdMix, hasParent);
}
exports("SetPedHeadBlend", setHeadBlend);
function setHeadOverlay(pedHandle, data) {
  if (!data)
    return console.warn("No data provided for setHeadOverlay");
  const index = data.index;
  const value = data.value || data.overlayValue;
  if (index === 13) {
    SetPedEyeColor(pedHandle, value);
    return;
  }
  if (data.id === "hairColor") {
    SetPedHairTint(pedHandle, data.hairColor, data.hairHighlight);
    return;
  }
  SetPedHeadOverlay(pedHandle, index, value, data.overlayOpacity + 0);
  SetPedHeadOverlayColor(pedHandle, index, 1, data.firstColor, data.secondColor);
}
exports("SetPedHeadOverlay", setHeadOverlay);
function resetToggles(data) {
  const drawables = data.drawables;
  const props = data.props;
  for (const [toggleItem, toggleData] of Object.entries(toggles_default)) {
    const toggleType = toggleData.type;
    const index = toggleData.index;
    if (toggleType === "drawable" && drawables[toggleItem]) {
      const currentDrawable = GetPedDrawableVariation(ped, index);
      if (currentDrawable !== drawables[toggleItem].value) {
        SetPedComponentVariation(ped, index, drawables[toggleItem].value, 0, 0);
      }
    } else if (toggleType === "prop" && props[toggleItem]) {
      const currentProp = GetPedPropIndex(ped, index);
      if (currentProp !== props[toggleItem].value) {
        SetPedPropIndex(ped, index, props[toggleItem].value, 0, false);
      }
    }
  }
}
exports("SetPedClothes", setPedClothes);
function setPedClothes(pedHandle, data) {
  if (!data)
    return console.warn("No data provided for setPedClothes");
  const drawables = data.drawables;
  const props = data.props;
  const headOverlay = data.headOverlay;
  for (const id in drawables) {
    const drawable = drawables[id];
    setDrawable(pedHandle, drawable);
  }
  for (const id in props) {
    const prop = props[id];
    setProp(pedHandle, prop);
  }
  if (headOverlay)
    for (const id in headOverlay) {
      const overlay = { ...headOverlay[id], id };
      setHeadOverlay(pedHandle, overlay);
    }
}
exports("SetPedClothes", setPedClothes);
var setPedSkin = async (pedHandle, data) => {
  if (!data)
    return console.warn("No data provided for setPedSkin");
  if (!pedHandle)
    return console.warn("No pedHandle provided for setPedSkin");
  pedHandle = await setModel(pedHandle, data);
  const headStructure = data.headStructure;
  const headBlend = data.headBlend;
  if (headBlend)
    setHeadBlend(pedHandle, headBlend);
  if (headStructure)
    setFaceFeatures(pedHandle, headStructure);
};
exports("SetPedSkin", setPedSkin);
function setPedTattoos(pedHandle, data) {
  if (!data)
    return console.warn("No data provided for setPedTattoos");
  ClearPedDecorationsLeaveScars(pedHandle);
  for (let i = 0; i < data.length; i++) {
    const tattooData = data[i].tattoo;
    if (tattooData) {
      const collection = GetHashKey(tattooData.dlc);
      const tattoo = tattooData.hash;
      const tattooOpacity = Math.round((tattooData.opacity || 0.1) * 10);
      for (let j = 0; j < tattooOpacity; j++) {
        AddPedDecorationFromHashes(pedHandle, collection, tattoo);
      }
    }
  }
}
exports("SetPedTattoos", setPedTattoos);
function setPedHairColors(pedHandle, data) {
  if (!data)
    return console.warn("No data provided for setPedHairColors");
  const color = data.color;
  const highlight = data.highlight;
  SetPedHairColor(pedHandle, color, highlight);
}
exports("SetPedHairColors", setPedHairColors);
async function setPedAppearance(pedHandle, data) {
  if (!data)
    return console.warn("No data provided for setPedAppearance");
  if (IsPedAPlayer(pedHandle)) {
    setPlayerPedAppearance(data);
    return;
  }
  await setPedSkin(pedHandle, data);
  setPedClothes(pedHandle, data);
  setPedHairColors(pedHandle, data.hairColor);
  setPedTattoos(pedHandle, data.tattoos);
}
exports("SetPedAppearance", setPedAppearance);
async function setPlayerPedAppearance(data) {
  if (!data)
    return console.warn("No data provided for setPlayerPedAppearance");
  updatePed(PlayerPedId());
  await setPedSkin(ped, data);
  updatePed(PlayerPedId());
  setPedClothes(ped, data);
  setPedHairColors(ped, data.hairColor);
  setPedTattoos(ped, data.tattoos);
}
exports("SetPedClothes", setPedClothes);
exports("SetPedSkin", setPedSkin);
exports("SetPedTattoos", setPedTattoos);
exports("SetPedHairColors", setPedHairColors);

// src/client/handlers.ts
RegisterNuiCallback("appearance:cancel" /* cancel */, async (appearance, cb) => {
  await setPlayerPedAppearance(appearance);
  closeMenu();
  cb(1);
});
RegisterNuiCallback("appearance:save" /* save */, async (appearance, cb) => {
  resetToggles(appearance);
  await delay(100);
  const newAppearance = await getAppearance(ped);
  newAppearance.tattoos = appearance.tattoos || null;
  triggerServerCallback("bl_appearance:server:saveAppearance", getFrameworkID(), newAppearance);
  setPedTattoos(ped, newAppearance.tattoos);
  closeMenu();
  cb(1);
});
RegisterNuiCallback("appearance:setModel" /* setModel */, async (model, cb) => {
  const hash = GetHashKey(model);
  if (!IsModelInCdimage(hash) || !IsModelValid(hash)) {
    return cb(0);
  }
  const newPed = await setModel(ped, hash);
  updatePed(newPed);
  const appearance = await getAppearance(ped);
  appearance.tattoos = [];
  setPedTattoos(ped, []);
  cb(appearance);
});
RegisterNuiCallback("appearance:getModelTattoos" /* getModelTattoos */, async (_, cb) => {
  const tattoos = getTattooData();
  cb(tattoos);
});
RegisterNuiCallback("appearance:setHeadStructure" /* setHeadStructure */, async (data, cb) => {
  setFaceFeature(ped, data);
  cb(1);
});
RegisterNuiCallback("appearance:setHeadOverlay" /* setHeadOverlay */, async (data, cb) => {
  setHeadOverlay(ped, data);
  cb(1);
});
RegisterNuiCallback("appearance:setHeadBlend" /* setHeadBlend */, async (data, cb) => {
  setHeadBlend(ped, data);
  cb(1);
});
RegisterNuiCallback("appearance:setTattoos" /* setTattoos */, async (data, cb) => {
  setPedTattoos(ped, data);
  cb(1);
});
RegisterNuiCallback("appearance:setProp" /* setProp */, async (data, cb) => {
  let texture = setProp(ped, data);
  cb(texture);
});
RegisterNuiCallback("appearance:setDrawable" /* setDrawable */, async (data, cb) => {
  let texture = setDrawable(ped, data);
  cb(texture);
});
RegisterNuiCallback(
  "appearance:toggleItem" /* toggleItem */,
  async (data, cb) => {
    const item = toggles_default[data.item];
    if (!item)
      return cb(false);
    const current = data.data;
    const type = item.type;
    const index = item.index;
    const hook = item.hook;
    const hookData = data.hookData;
    if (!current)
      return cb(false);
    if (type === "prop") {
      const currentProp = GetPedPropIndex(ped, index);
      if (currentProp === -1) {
        setProp(ped, current);
        cb(false);
        return;
      } else {
        ClearPedProp(ped, index);
        cb(true);
        return;
      }
    } else if (type === "drawable") {
      const currentDrawable = GetPedDrawableVariation(ped, index);
      if (current.value === item.off) {
        cb(false);
        return;
      }
      if (current.value === currentDrawable) {
        SetPedComponentVariation(ped, index, item.off, 0, 0);
        if (hook) {
          for (let i = 0; i < hook.drawables?.length; i++) {
            const hookItem = hook.drawables[i];
            SetPedComponentVariation(ped, hookItem.component, hookItem.variant, hookItem.texture, 0);
          }
        }
        cb(true);
        return;
      } else {
        setDrawable(ped, current);
        for (let i = 0; i < hookData?.length; i++) {
          setDrawable(ped, hookData[i]);
        }
        cb(false);
        return;
      }
    }
  }
);
RegisterNuiCallback("appearance:saveOutfit" /* saveOutfit */, async (data, cb) => {
  const result = await triggerServerCallback("bl_appearance:server:saveOutfit", data);
  cb(result);
});
RegisterNuiCallback("appearance:deleteOutfit" /* deleteOutfit */, async ({ id }, cb) => {
  const result = await triggerServerCallback("bl_appearance:server:deleteOutfit", id);
  cb(result);
});
RegisterNuiCallback("appearance:renameOutfit" /* renameOutfit */, async (data, cb) => {
  const result = await triggerServerCallback("bl_appearance:server:renameOutfit", data);
  cb(result);
});
RegisterNuiCallback("appearance:useOutfit" /* useOutfit */, async (outfit, cb) => {
  setPedClothes(ped, outfit);
  cb(1);
});
RegisterNuiCallback("appearance:importOutfit" /* importOutfit */, async ({ id, outfitName }, cb) => {
  const frameworkdId = getFrameworkID();
  const result = await triggerServerCallback("bl_appearance:server:importOutfit", frameworkdId, id, outfitName);
  cb(result);
});
RegisterNuiCallback("appearance:fetchOutfit" /* fetchOutfit */, async ({ id }, cb) => {
  const result = await triggerServerCallback("bl_appearance:server:fetchOutfit", id);
  cb(result);
});
RegisterNuiCallback("appearance:itemOutfit" /* itemOutfit */, async (data, cb) => {
  const result = await triggerServerCallback("bl_appearance:server:itemOutfit", data);
  cb(result);
});
var animDict = "missmic4";
var anim = "michael_tux_fidget";
async function playOutfitEmote() {
  while (!HasAnimDictLoaded(animDict)) {
    RequestAnimDict(animDict);
    await Delay(100);
  }
  TaskPlayAnim(ped, animDict, anim, 3, 3, 1200, 51, 0, false, false, false);
}
onNet("bl_appearance:client:useOutfitItem", async (outfit) => {
  await playOutfitEmote();
  setPedClothes(ped, outfit);
  triggerServerCallback("bl_appearance:server:saveClothes", getFrameworkID(), outfit);
});

// src/client/menu.ts
var config = exports.bl_appearance;
var armour = 0;
var open = false;
var resolvePromise = null;
var promise = null;
async function openMenu(zone, creation = false) {
  if (zone === null || open) {
    return;
  }
  let pedHandle = PlayerPedId();
  const configMenus = config.menus();
  const isString = typeof zone === "string";
  const type = isString ? zone : zone.type;
  const menu = configMenus[type];
  if (!menu)
    return;
  updatePed(pedHandle);
  const frameworkdId = getFrameworkID();
  const tabs = menu.tabs;
  let allowExit = creation ? false : menu.allowExit;
  armour = GetPedArmour(pedHandle);
  const outfits = tabs.includes("outfits") && await triggerServerCallback("bl_appearance:server:getOutfits", frameworkdId);
  const models = tabs.includes("heritage") && getAllowlist(config.models());
  const tattoos = tabs.includes("tattoos") && getTattooData();
  const blacklist = getBlacklist(zone);
  if (creation) {
    const model = GetHashKey(getPlayerGenderModel());
    pedHandle = await setModel(pedHandle, model);
    emitNet("bl_appearance:server:setroutingbucket");
    promise = new Promise((resolve) => {
      resolvePromise = resolve;
    });
    updatePed(pedHandle);
  }
  const appearance = await getAppearance(pedHandle);
  startCamera();
  sendNUIEvent("appearance:data" /* data */, {
    tabs,
    appearance,
    blacklist,
    tattoos,
    outfits,
    models,
    allowExit,
    job: getJobInfo(),
    locale: await requestLocale("locale")
  });
  SetNuiFocus(true, true);
  sendNUIEvent("appearance:visible" /* visible */, true);
  open = true;
  exports.bl_appearance.hideHud(true);
  if (promise) {
    await promise;
    emitNet("bl_appearance:server:resetroutingbucket");
  }
  promise = null;
  resolvePromise = null;
  return true;
}
exports("OpenMenu", openMenu);
function getAllowlist(models) {
  const { allowList } = config.blacklist();
  const playerData = getPlayerData();
  const allowlistModels = allowList.characters[playerData.cid];
  if (!allowlistModels)
    return models;
  models.forEach((model) => {
    if (!allowlistModels.includes(model)) {
      allowlistModels.push(model);
    }
  });
  return allowlistModels;
}
function getBlacklist(zone) {
  const { groupTypes, base } = config.blacklist();
  if (typeof zone === "string")
    return base;
  if (!groupTypes)
    return base;
  let blacklist = { ...base };
  const playerData = getPlayerData();
  for (const type in groupTypes) {
    const groups = groupTypes[type];
    for (const group in groups) {
      let skip = false;
      if (type == "jobs" && zone.jobs) {
        skip = zone.jobs.includes(playerData.job.name);
      }
      if (type == "gangs" && zone.gangs) {
        skip = zone.gangs.includes(playerData.gang.name);
      }
      if (!skip) {
        const groupBlacklist = groups[group];
        blacklist = Object.assign({}, blacklist, groupBlacklist, {
          drawables: Object.assign({}, blacklist.drawables, groupBlacklist.drawables)
        });
      }
    }
  }
  return blacklist;
}
function closeMenu() {
  SetPedArmour(ped, armour);
  stopCamera();
  SetNuiFocus(false, false);
  sendNUIEvent("appearance:visible" /* visible */, false);
  exports.bl_appearance.hideHud(false);
  if (resolvePromise) {
    resolvePromise();
  }
  open = false;
}

// src/client/bridge/qb.ts
function QBBridge() {
  onNet("qb-clothing:client:loadPlayerClothing", async (appearance, ped3) => {
    await setPedAppearance(ped3, appearance);
  });
  onNet("qb-clothes:client:CreateFirstCharacter", () => {
    exports.bl_appearance.InitialCreation();
  });
  onNet("qb-clothing:client:openOutfitMenu", () => {
    openMenu({ type: "outfits", coords: [0, 0, 0, 0] });
  });
}

// src/client/bridge/esx.ts
function ESXBridge() {
  let firstSpawn = false;
  on("esx_skin:resetFirstSpawn", () => {
    firstSpawn = true;
  });
  on("esx_skin:playerRegistered", () => {
    if (firstSpawn)
      exports.bl_appearance.InitialCreation();
  });
  onNet("skinchanger:loadSkin2", async (appearance, ped3) => {
    if (!appearance.model)
      appearance.model = GetHashKey("mp_m_freemode_01");
    await setPedAppearance(ped3, appearance);
  });
  onNet("skinchanger:getSkin", async (cb) => {
    const frameworkID = await getFrameworkID();
    const appearance = await triggerServerCallback("bl_appearance:server:getAppearance", frameworkID);
    cb(appearance);
  });
  onNet("skinchanger:loadSkin", async (appearance, cb) => {
    await setPlayerPedAppearance(appearance);
    if (cb)
      cb();
  });
  onNet("esx_skin:openSaveableMenu", async (onSubmit) => {
    exports.bl_appearance.InitialCreation(onSubmit);
  });
}

// src/client/compat/illenium.ts
function exportHandler(name, cb) {
  on("__cfx_export_illenium-appearance_" + name, (setCB) => {
    setCB(cb);
  });
}
function illeniumCompat() {
  exportHandler("startPlayerCustomization", () => {
    exports.bl_appearance.InitialCreation();
  });
  exportHandler("getPedModel", (ped3) => {
    return GetEntityModel(ped3);
  });
  exportHandler("getPedComponents", (ped3) => {
    const drawables = getDrawables(ped3)[0];
    let newdrawable = [];
    for (const id of drawables) {
      const drawable = drawables[id];
      newdrawable.push({
        component_id: drawable.index,
        drawable: drawable.value,
        texture: drawable.texture
      });
    }
  });
  exportHandler("getPedProps", (ped3) => {
    const props = getProps(ped3)[0];
    let newProps = [];
    for (const id of props) {
      const prop = props[id];
      newProps.push({
        prop_id: prop.index,
        drawable: prop.value,
        texture: prop.texture
      });
    }
  });
  exportHandler("getPedHeadBlend", (ped3) => {
    return getHeadBlendData(ped3);
  });
  exportHandler("getPedFaceFeatures", (ped3) => {
    const convertKey = {
      Nose_Width: "noseWidth",
      Nose_Peak_Height: "nosePeakHigh",
      Nose_Peak_Lenght: "nosePeakSize",
      Nose_Bone_Height: "noseBoneHigh",
      Nose_Peak_Lowering: "nosePeakLowering",
      Nose_Bone_Twist: "noseBoneTwist",
      EyeBrown_Height: "eyeBrownHigh",
      EyeBrown_Forward: "eyeBrownForward",
      Cheeks_Bone_High: "cheeksBoneHigh",
      Cheeks_Bone_Width: "cheeksBoneWidth",
      Cheeks_Width: "cheeksWidth",
      Eyes_Openning: "eyesOpening",
      Lips_Thickness: "lipsThickness",
      Jaw_Bone_Width: "jawBoneWidth",
      Jaw_Bone_Back_Lenght: "jawBoneBackSize",
      Chin_Bone_Lowering: "chinBoneLowering",
      Chin_Bone_Length: "chinBoneLenght",
      Chin_Bone_Width: "chinBoneSize",
      Chin_Hole: "chinHole",
      Neck_Thikness: "neckThickness"
    };
    const faceFeature = getHeadStructure(ped3);
    let faceFeatureConverted = {};
    for (const key in convertKey) {
      const data = faceFeature[key];
      faceFeatureConverted[convertKey[key]] = data.value;
    }
    return faceFeatureConverted;
  });
  exportHandler("getPedHeadOverlays", (ped3) => {
    const convertKey = {
      sunDamage: "SunDamage",
      bodyBlemishes: "BodyBlemishes",
      chestHair: "ChestHair",
      complexion: "Complexion",
      blemishes: "Blemishes",
      ageing: "Ageing",
      lipstick: "Lipstick",
      eyebrows: "Eyebrows",
      beard: "Beard",
      makeUp: "Makeup",
      blush: "Blush",
      moleAndFreckles: "MolesFreckles",
      eyeColor: "EyeColor"
    };
    const pedFeature = getHeadOverlay(ped3);
    let pedFeatureConverted = {};
    for (const key in convertKey) {
      const data = pedFeature[convertKey[key]];
      pedFeatureConverted[key] = {
        secondColor: data.secondColor,
        style: data.overlayValue,
        opacity: data.overlayOpacity,
        color: data.firstColor
      };
    }
    return pedFeatureConverted;
  });
  exportHandler("getPedHair", (ped3) => {
    return {
      style: GetPedDrawableVariation(ped3, 2),
      color: GetPedHairColor(ped3),
      highlight: GetPedHairHighlightColor(ped3),
      texture: GetPedTextureVariation(ped3, 2)
    };
  });
  exportHandler("getPedAppearance", (ped3) => {
    return getAppearance(ped3);
  });
  exportHandler("setPlayerModel", (model) => {
    updatePed(PlayerPedId());
    setModel(ped, model);
  });
  exportHandler("setPedHeadBlend", (ped3, blend) => {
    setHeadBlend(ped3, blend);
  });
  exportHandler("setPedFaceFeatures", (ped3, faceFeatures) => {
    const indexTable = {
      noseWidth: 0,
      nosePeakHigh: 1,
      nosePeakSize: 2,
      noseBoneHigh: 3,
      nosePeakLowering: 4,
      noseBoneTwist: 5,
      eyeBrownHigh: 6,
      eyeBrownForward: 7,
      cheeksBoneHigh: 8,
      cheeksBoneWidth: 9,
      cheeksWidth: 10,
      eyesOpening: 11,
      lipsThickness: 12,
      jawBoneWidth: 13,
      jawBoneBackSize: 14,
      chinBoneLowering: 15,
      chinBoneLenght: 16,
      chinBoneSize: 17,
      chinHole: 18,
      neckThickness: 19
    };
    for (const key in faceFeatures) {
      const value = faceFeatures[key] + 0;
      SetPedFaceFeature(ped3, indexTable[key], value);
    }
  });
  exportHandler("setPedHeadOverlays", (ped3, overlay) => {
    const convertKey = {
      sunDamage: "SunDamage",
      bodyBlemishes: "BodyBlemishes",
      chestHair: "ChestHair",
      complexion: "Complexion",
      blemishes: "Blemishes",
      ageing: "Ageing",
      lipstick: "Lipstick",
      eyebrows: "Eyebrows",
      beard: "Beard",
      makeUp: "Makeup",
      blush: "Blush",
      moleAndFreckles: "MolesFreckles",
      eyeColor: "EyeColor"
    };
    const index = {
      Blemishes: 0,
      FacialHair: 1,
      Eyebrows: 2,
      Ageing: 3,
      Makeup: 4,
      Blush: 5,
      Complexion: 6,
      SunDamage: 7,
      Lipstick: 8,
      MolesFreckles: 9,
      ChestHair: 10,
      BodyBlemishes: 11,
      AddBodyBlemishes: 12,
      EyeColor: 13
    };
    let convertedOverlay = {};
    for (const key in overlay) {
      const data = overlay[key];
      const overlayKey = convertKey[key];
      convertedOverlay[overlayKey] = {
        id: overlayKey,
        index: index[overlayKey],
        overlayValue: data.opacity,
        colourType: 1,
        firstColor: data.color,
        secondColor: data.secondColor,
        overlayOpacity: data.opacity
      };
    }
    setHeadOverlay(ped3, convertedOverlay);
  });
  exportHandler("setPedHair", async (ped3, hair, tattoo) => {
    SetPedComponentVariation(ped3, 2, hair.style, hair.texture, 0);
    SetPedHairColor(ped3, hair.color, hair.highlight);
  });
  exportHandler("setPedEyeColor", (ped3, eyeColor) => {
    SetPedEyeColor(ped3, eyeColor);
  });
  exportHandler("setPedComponent", (ped3, drawable) => {
    const newDrawable = {
      index: drawable.component_id,
      value: drawable.drawable,
      texture: drawable.texture
    };
    setDrawable(ped3, newDrawable);
  });
  exportHandler("setPedComponents", (ped3, components) => {
    for (const component of components) {
      const newDrawable = {
        index: component.component_id,
        value: component.drawable,
        texture: component.texture
      };
      setDrawable(ped3, newDrawable);
    }
  });
  exportHandler("setPedProp", (ped3, prop) => {
    const newProp = {
      index: prop.prop_id,
      value: prop.drawable,
      texture: prop.texture
    };
    setProp(ped3, newProp);
  });
  exportHandler("setPedProps", (ped3, props) => {
    for (const prop of props) {
      const newProp = {
        index: prop.prop_id,
        value: prop.drawable,
        texture: prop.texture
      };
      setProp(ped3, newProp);
    }
  });
  exportHandler("setPedAppearance", (ped3, appearance) => {
    setPedAppearance(ped3, appearance);
  });
  exportHandler("setPedTattoos", (ped3, tattoos) => {
    setPedTattoos(ped3, tattoos);
  });
}

// src/client/init.ts
exports("SetPlayerPedAppearance", async (appearance) => {
  let resolvedAppearance;
  if (!appearance || typeof appearance === "string") {
    const frameworkID = appearance || await getFrameworkID();
    resolvedAppearance = await triggerServerCallback("bl_appearance:server:getAppearance", frameworkID);
  } else if (typeof appearance === "object")
    resolvedAppearance = appearance;
  if (!resolvedAppearance) {
    throw new Error("No valid appearance found");
  }
  await setPlayerPedAppearance(resolvedAppearance);
});
exports("GetPlayerPedAppearance", async (frameworkID) => {
  frameworkID = frameworkID || await getFrameworkID();
  return await triggerServerCallback("bl_appearance:server:getAppearance", frameworkID);
});
exports("InitialCreation", async (cb) => {
  await openMenu({ type: "appearance", coords: [0, 0, 0, 0] }, true);
  if (cb)
    cb();
});
on("bl_appearance:client:useZone", (zone) => {
  openMenu(zone);
});
onNet("bl_appearance:client:open", (zone) => {
  openMenu(zone);
});
onNet("bl_bridge:client:playerLoaded", async () => {
  while (!bl_bridge.core().playerLoaded()) {
    await Delay(100);
  }
  const frameworkID = await getFrameworkID();
  const appearance = await triggerServerCallback("bl_appearance:server:getAppearance", frameworkID);
  if (!appearance)
    return;
  await setPlayerPedAppearance(appearance);
});
onNet("onResourceStart", async (resource) => {
  if (resource === GetCurrentResourceName() && bl_bridge.core().playerLoaded()) {
    const frameworkID = await getFrameworkID();
    const appearance = await triggerServerCallback("bl_appearance:server:getAppearance", frameworkID);
    if (!appearance)
      return;
    await setPlayerPedAppearance(appearance);
  }
});
var frameworkName = bl_bridge.getFramework("core");
var core = format(GetConvar("bl:framework", "qb"));
if (core == "qb" || core == "qbx" && GetResourceState(frameworkName) == "started") {
  QBBridge();
} else if (core == "esx" && GetResourceState(frameworkName) == "started") {
  ESXBridge();
}
illeniumCompat();
async function reloadSkin() {
  const frameworkID = await getFrameworkID();
  const ped3 = PlayerPedId();
  const maxhealth = GetEntityMaxHealth(ped3);
  const health = GetEntityHealth(ped3);
  const armor = GetPedArmour(ped3);
  const appearance = await triggerServerCallback("bl_appearance:server:getAppearance", frameworkID);
  if (!appearance)
    return;
  await setPlayerPedAppearance(appearance);
  SetPedMaxHealth(ped3, maxhealth);
  await Delay(1e3);
  SetEntityHealth(ped3, health);
  SetPedArmour(ped3, armor);
}
onNet("bl_appearance:client:reloadSkin", async () => await reloadSkin());
RegisterCommand("reloadskin", async () => await reloadSkin(), false);
