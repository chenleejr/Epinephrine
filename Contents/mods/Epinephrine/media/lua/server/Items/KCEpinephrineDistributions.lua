require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"
require "Vehicles/VehicleDistributions"
require "Items/ItemPicker"

-- Vehicles
table.insert(VehicleDistributions.SurvivalistTruckBed.items, "KCEpinephrineItems.KCEpinephrine");
table.insert(VehicleDistributions.SurvivalistTruckBed.items, 5);
table.insert(VehicleDistributions.DoctorTruckBed.items, "KCEpinephrineItems.KCEpinephrine");
table.insert(VehicleDistributions.DoctorTruckBed.items, 5);

-- Procedural SuburbsDistributions
table.insert(ProceduralDistributions.list["StoreShelfMedical"].items, "KCEpinephrineItems.KCEpinephrine");
table.insert(ProceduralDistributions.list["StoreShelfMedical"].items, 5);

-- Medical Facilities
table.insert(ProceduralDistributions.list["MedicalClinicDrugs"].items, "KCEpinephrineItems.KCEpinephrine");
table.insert(ProceduralDistributions.list["MedicalClinicDrugs"].items, 5);
table.insert(ProceduralDistributions.list["MedicalStorageDrugs"].items, "KCEpinephrineItems.KCEpinephrine");
table.insert(ProceduralDistributions.list["MedicalStorageDrugs"].items, 5);
table.insert(SuburbsDistributions["all"]["medicine"].items, "KCEpinephrineItems.KCEpinephrine");
table.insert(SuburbsDistributions["all"]["medicine"].items, 5);

-- Other Places
table.insert(SuburbsDistributions["FirstAidKit"].items, "KCEpinephrineItems.KCEpinephrine");
table.insert(SuburbsDistributions["FirstAidKit"].items, 5);