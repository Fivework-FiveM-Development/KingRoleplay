Config = {};

Config.IdCardSettings = {
   closeKey = 'Escape',
   autoClose = {
      status = true, -- or true
      time = 3000
   }
};

Config.Licenses = {
   ['id_card'] = {
      header = 'Identidade',
      background = '#ebf7fd',
      prop = 'prop_franklin_dl'
   },
   ['driver_license'] = {
      header = 'Carteira de Motorista',
      background = '#febbbb',
      prop = 'prop_franklin_dl',
   },
   ['weaponlicense'] = {
      header = 'Porte de Arma',
      background = '#c7ffe5',
      prop = 'prop_franklin_dl',
   },
   ['lawyerpass'] = {
      header = 'Licença de Advogado',
      background = '#f9c491',
      prop = 'prop_cs_r_business_card'
   },
}
