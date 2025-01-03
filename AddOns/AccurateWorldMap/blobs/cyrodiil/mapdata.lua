local theme = AccurateWorldMap
local maps = theme.maps
local tamriel = maps[27]
local ic = maps[660]
local prefix = theme.prefix


-------------------
-- Imperial City --
--tamriel.pois[247] = { xN = 0.5505, yN = 0.4865 }   -- White-Gold Tower
--tamriel.pois[236] = { xN = 0.5565, yN = 0.474 }    -- Imperial City Prison

--------------
-- Cyrodiil --
tamriel.zones[16] = {
   textureFile = prefix.."/blobs/cyrodiil/blob-cyrodiil.dds",
   bounds = { xN = 0.44897, yN = 0.38818, widthN = 0.22326, heightN = 0.22326 },
   hitbox = {
      { xN = 0.1232, yN = 0.0660, },
      { xN = 0.1222, yN = 0.0906, },
      { xN = 0.1113, yN = 0.0995, },
      { xN = 0.0296, yN = 0.2334, },
      { xN = 0.0178, yN = 0.2777, },
      { xN = 0.0710, yN = 0.3929, },
      { xN = 0.0966, yN = 0.4224, },
      { xN = 0.1320, yN = 0.4313, },
      { xN = 0.1429, yN = 0.4795, },
      { xN = 0.1576, yN = 0.5081, },
      { xN = 0.1921, yN = 0.6075, },
      { xN = 0.2147, yN = 0.6607, },
      { xN = 0.2817, yN = 0.7533, },
      { xN = 0.3627, yN = 0.8280, },
      { xN = 0.3577, yN = 0.8563, },
      { xN = 0.3709, yN = 0.8827, },
      { xN = 0.3583, yN = 0.9311, },
      { xN = 0.3653, yN = 0.9487, },
      { xN = 0.3986, yN = 0.9544, },
      { xN = 0.4331, yN = 0.9299, },
      { xN = 0.4671, yN = 0.9443, },
      { xN = 0.5293, yN = 0.9632, },
      { xN = 0.5658, yN = 0.9644, },
      { xN = 0.5765, yN = 0.9575, },
      { xN = 0.6412, yN = 0.9632, },
      { xN = 0.6588, yN = 0.9575, },
      { xN = 0.6632, yN = 0.9098, },
      { xN = 0.6770, yN = 0.8834, },
      { xN = 0.6846, yN = 0.8607, },
      { xN = 0.6959, yN = 0.8117, },
      { xN = 0.6978, yN = 0.7652, },
      { xN = 0.7682, yN = 0.7187, },
      { xN = 0.8409, yN = 0.6088, },
      { xN = 0.8531, yN = 0.5693, },
      { xN = 0.8493, yN = 0.5596, },
      { xN = 0.8495, yN = 0.5292, },
      { xN = 0.8965, yN = 0.4880, },
      { xN = 0.9204, yN = 0.4189, },
      { xN = 0.9531, yN = 0.3774, },
      { xN = 0.9700, yN = 0.3674, },
      { xN = 0.9989, yN = 0.3328, },
      { xN = 0.9977, yN = 0.3152, },
      { xN = 0.9977, yN = 0.2866, },
      { xN = 0.9626, yN = 0.2354, },
      { xN = 0.9386, yN = 0.2139, },
      { xN = 0.9514, yN = 0.1773, },
      { xN = 0.9285, yN = 0.1147, },
      { xN = 0.9014, yN = 0.0904, },
      { xN = 0.8753, yN = 0.0845, },
      { xN = 0.8534, yN = 0.0883, },
      { xN = 0.7967, yN = 0.1111, },
      { xN = 0.7521, yN = 0.0956, },
      { xN = 0.6949, yN = 0.0879, },
      { xN = 0.6483, yN = 0.1006, },
      { xN = 0.6113, yN = 0.0899, },
      { xN = 0.5945, yN = 0.0818, },
      { xN = 0.5679, yN = 0.0844, },
      { xN = 0.5271, yN = 0.0680, },
      { xN = 0.4880, yN = 0.0549, },
      { xN = 0.4590, yN = 0.0584, },
      { xN = 0.4348, yN = 0.0765, },
      { xN = 0.4105, yN = 0.0785, },
      { xN = 0.3903, yN = 0.0661, },
      { xN = 0.3455, yN = 0.0550, },
      { xN = 0.3153, yN = 0.0651, },
      { xN = 0.2955, yN = 0.0802, },
      { xN = 0.2778, yN = 0.0941, },
      { xN = 0.1958, yN = 0.0712, },
      { xN = 0.1702, yN = 0.0688, },
      { xN = 0.1471, yN = 0.0617, },   
   }
}

-- Sewers map --
ic.zones[900] = {
   textureFile = prefix.."/blobs/aurbis/blob-realm.dds",
   bounds = { xN = 0.035, yN = 0.0345, widthN = 0.16, heightN = 0.16, },
   hitbox = {
      { xN = 0.473, yN = 0.005 },
      { xN = 0.352, yN = 0.027 },
      { xN = 0.259, yN = 0.067 },
      { xN = 0.169, yN = 0.128 },
      { xN = 0.070, yN = 0.252 },
      { xN = 0.029, yN = 0.354 },
      { xN = 0.007, yN = 0.431 },
      { xN = 0.003, yN = 0.479 },
      { xN = 0.013, yN = 0.596 },
      { xN = 0.034, yN = 0.673 },
      { xN = 0.075, yN = 0.763 },
      { xN = 0.259, yN = 0.067 },
      { xN = 0.169, yN = 0.128 },
      { xN = 0.070, yN = 0.252 },
      { xN = 0.029, yN = 0.354 },
      { xN = 0.007, yN = 0.431 },
      { xN = 0.003, yN = 0.479 },
      { xN = 0.013, yN = 0.596 },
      { xN = 0.034, yN = 0.673 },
      { xN = 0.075, yN = 0.763 },
      { xN = 0.146, yN = 0.848 },
      { xN = 0.241, yN = 0.921 },
      { xN = 0.342, yN = 0.971 },
      { xN = 0.441, yN = 0.992 },
      { xN = 0.540, yN = 0.994 },
      { xN = 0.666, yN = 0.970 },
      { xN = 0.745, yN = 0.934 },
      { xN = 0.831, yN = 0.872 },
      { xN = 0.889, yN = 0.807 },
      { xN = 0.946, yN = 0.723 },
      { xN = 0.973, yN = 0.644 },
      { xN = 0.994, yN = 0.548 },
      { xN = 0.998, yN = 0.499 },
      { xN = 0.997, yN = 0.471 },
      { xN = 0.990, yN = 0.426 },
      { xN = 0.977, yN = 0.360 },
      { xN = 0.961, yN = 0.311 },
      { xN = 0.913, yN = 0.223 },
      { xN = 0.808, yN = 0.111 },
      { xN = 0.738, yN = 0.066 },
      { xN = 0.616, yN = 0.020 },
      { xN = 0.549, yN = 0.006 },   
   },
}