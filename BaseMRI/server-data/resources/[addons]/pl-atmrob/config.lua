lib.locale()

Config = {}

Config.Inv = 'ox' --'qb', 'newqb' For QBCore Only

Config.AtmModels = {'prop_fleeca_atm', 'prop_atm_01', 'prop_atm_02', 'prop_atm_03'}

Config.Notify = 'ox' --ox, esx, okok,qb,wasabi,custom

Config.Target = 'ox-target' --qtarget, qb-target, ox-target

Config.Hacking = {
    Minigame = 'utk_fingerprint', --utk_fingerprint, ox_lib
    InitialHackDuration = 2000, --2 seconds
    LootAtmDuration = 20000 --20 seconds
}

Config.CooldownTimer = 300 -- default 10 minutes | 60 = 1 minute

Config.Reward = {
    account = 'black_money', --bank, cash, dirty
    amount = 15000
}

Config.Police = {
    notify = true,
    required = 0,
    Job = 'police'
}
