Aqui está o conteúdo atualizado em formato Markdown (.md), com instruções para modificar o arquivo handling.meta do veículo Add-On "Mustang" no recurso myaddoncar para FiveM com QBox. O texto inclui todos os arquivos necessários, explicações sobre o handling e passos para teste/integration.
Atualizando o Handling do Veículo Add-On: myaddoncar
Este guia explica como modificar o handling (comportamento físico) do veículo Add-On "Ford Mustang" no recurso myaddoncar para FiveM com QBox, ajustando-o como uma viatura policial ágil e estável. O handling controla velocidade, aceleração, frenagem, tração e suspensão.
O que é Handling?
O arquivo handling.meta define como o veículo se comporta no jogo. Exemplos de ajustes:
Velocidade Máxima: fInitialDriveMaxFlatVel
Aceleração: fInitialDriveForce
Frenagem: fBrakeForce
Tração: fDriveBiasFront
Estrutura do Recurso
myaddoncar/
├── data/
│   ├── vehicles.meta
│   ├── handling.meta
│   ├── carvariations.meta
├── stream/
│   ├── mustang.yft
│   ├── mustang.ytd
├── fxmanifest.lua
Modificando o Handling
Arquivo: data/handling.meta
Abaixo está o handling atualizado para o "Mustang PMESP":
xml
<?xml version="1.0" encoding="UTF-8"?>
<CHandlingDataMgr>
  <HandlingData>
    <Item type="CHandlingData">
      <handlingName>MUSTANG</handlingName>
      <fMass value="1600.000000" /> <!-- Massa do veículo (kg) -->
      <fInitialDragCoeff value="0.200000" /> <!-- Resistência ao ar -->
      <fDriveBiasFront value="0.400000" /> <!-- Tração: 0=RWD, 1=FWD, 0.4=AWD leve -->
      <nInitialDriveGears value="6" /> <!-- Número de marchas -->
      <fInitialDriveForce value="0.350000" /> <!-- Aceleração (rápida) -->
      <fDriveInertia value="1.200000" /> <!-- Resposta do motor -->
      <fClutchChangeRateScaleUpShift value="4.000000" /> <!-- Troca de marcha (subindo) -->
      <fClutchChangeRateScaleDownShift value="4.000000" /> <!-- Troca de marcha (descendo) -->
      <fInitialDriveMaxFlatVel value="160.000000" /> <!-- Velocidade máxima (~288 km/h) -->
      <fBrakeForce value="0.800000" /> <!-- Força de frenagem -->
      <fHandBrakeForce value="1.000000" /> <!-- Freio de mão -->
      <fSteeringLock value="40.000000" /> <!-- Ângulo de direção -->
      <fTractionCurveMax value="2.500000" /> <!-- Aderência máxima -->
      <fTractionCurveMin value="2.300000" /> <!-- Aderência mínima -->
      <fTractionCurveLateral value="22.500000" /> <!-- Estabilidade em curvas -->
      <fLowSpeedTractionLossMult value="0.800000" /> <!-- Perda de tração em baixa velocidade -->
      <fSuspensionForce value="2.500000" /> <!-- Rigidez da suspensão -->
      <fSuspensionCompDamp value="1.500000" /> <!-- Amortecimento (compressão) -->
      <fSuspensionReboundDamp value="2.000000" /> <!-- Amortecimento (rebote) -->
      <fSuspensionUpperLimit value="0.100000" /> <!-- Altura máxima da suspensão -->
      <fSuspensionLowerLimit value="-0.150000" /> <!-- Altura mínima -->
      <fSuspensionRaise value="0.000000" /> <!-- Altura padrão -->
    </Item>
  </HandlingData>
</CHandlingDataMgr>
Ajustes Realizados
Velocidade Máxima: ~288 km/h (fInitialDriveMaxFlatVel = 160).
Aceleração: Rápida (fInitialDriveForce = 0.35).
Frenagem: Forte (fBrakeForce = 0.8, fHandBrakeForce = 1.0).
Tração: AWD leve (fDriveBiasFront = 0.4) com boa aderência.
Suspensão: Firme para estabilidade.
Arquivos do Recurso
data/vehicles.meta
xml
<?xml version="1.0" encoding="UTF-8"?>
<CVehicleModelInfo__InitDataList>
  <residentTxd>vehshare</residentTxd>
  <residentAnims />
  <InitDatas>
    <Item>
      <modelName>mustang</modelName>
      <txdName>mustang</txdName>
      <handlingId>MUSTANG</handlingId>
      <gameName>MUSTANG</gameName>
      <vehicleMakeName>FORD</vehicleMakeName>
      <expressionDictName>null</expressionDictName>
      <expressionName>null</expressionName>
      <animConvRoofDictName>null</animConvRoofDictName>
      <animConvRoofName>null</animConvRoofName>
      <animConvRoofWindowsAffected />
      <ptfxAssetName>null</ptfxAssetName>
      <layout>LAYOUT_STANDARD</layout>
      <type>VEHICLE_TYPE_CAR</type>
      <plateType>VPT_BACK_PLATES</plateType>
      <vehicleClass>VC_SPORT</vehicleClass>
      <wheelType>VWT_SPORT</wheelType>
      <trailers />
      <additionalTrailers />
      <drivers />
      <flags>FLAG_SPORTS FLAG_LAW_ENFORCEMENT</flags>
      <extraFlags />
    </Item>
  </InitDatas>
</CVehicleModelInfo__InitDataList>
data/carvariations.meta
xml
<?xml version="1.0" encoding="UTF-8"?>
<CVehicleModelInfoVariation>
  <variationData>
    <Item>
      <modelName>mustang</modelName>
      <colors>
        <Item>
          <colour1>0</colour1> <!-- Preto -->
          <colour2>0</colour2>
        </Item>
      </colors>
    </Item>
  </variationData>
</CVehicleModelInfoVariation>
fxmanifest.lua
lua
fx_version 'cerulean'
game 'gta5'

author 'Sergio Barros'
description 'Veículo Add-On Mustang para FiveM'
version '1.0.0'

files {
    'data/vehicles.meta',
    'data/handling.meta',
    'data/carvariations.meta'
}

data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'
data_file 'HANDLING_FILE' 'data/handling.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'
stream/
mustang.yft: Modelo 3D do veículo.
mustang.ytd: Texturas (ex.: skin PMESP).
Testando o Handling
Instale no Servidor:
Copie myaddoncar/ para resources/.
Adicione ao server.cfg:
ensure myaddoncar
Reinicie: refresh e restart myaddoncar.
Spawne o Veículo:
Use /car mustang ou um trainer.
Teste o Comportamento:
Acelere: Verifique a velocidade (~288 km/h).
Freie: Teste a resposta dos freios.
Curvas: Avalie a estabilidade.
Ajuste o Handling:
Mais Rápido: Aumente fInitialDriveMaxFlatVel (ex.: 180 para ~324 km/h).
Mais Firme: Aumente fSuspensionForce (ex.: 3.0).
Integração com QBox
Adicione ao sistema de garagem/jobs:
qbx_core/shared/vehicles.lua
lua
["mustang"] = {
    ["name"] = "Ford Mustang PMESP",
    ["brand"] = "Ford",
    ["model"] = "mustang",
    ["price"] = 50000,
    ["category"] = "police"
},
qbx_core/shared/jobs.lua
lua
["pmesp"] = {
    label = "Polícia Militar",
    grades = {
        ["soldado"] = { name = "Soldado", payment = 100 },
        ["tenente"] = { name = "Tenente", payment = 200 }
    },
    vehicles = {
        ["mustang"] = true
    }
}
Solução de Problemas
Handling Não Aplicado: Confirme que <handlingId>MUSTANG</handlingId> em vehicles.meta coincide com handlingName em handling.meta.
Veículo Não Aparece: Verifique stream/mustang.yft e mustang.ytd.
Comportamento Errado: Ajuste valores no handling.meta e recarregue o recurso.
Quer sugerir ajustes no handling (ex.: mais velocidade, melhor tração)? Me avise!