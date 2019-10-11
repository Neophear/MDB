DECLARE @LastId INT

EXEC dbo.UnitInsert 'TRR', 'Trænregimentet', '370929', @LastId OUTPUT
EXEC dbo.UnitInsert 'LG', 'Livgarden', '370929', @LastId OUTPUT
EXEC dbo.UnitInsert 'FMI', 'Forsvarets Materiel- og Indkøbsstyrelse', '370929', @LastId OUTPUT

EXEC dbo.DeviceInsert '358897070011843', 'Microsoft Lumia 550', 'Telenor', '1', '2017-03-08', 1, 1, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec efficitur aliquam risus in tristique. Curabitur lacinia pellentesque urna sit amet ultricies. Phasellus sed felis sollicitudin, ultricies velit sed, porta libero. Cras vehicula odio vitae sem dignissim, sit amet vestibulum sapien ultricies. Curabitur commodo ex condimentum orci lacinia, eu vestibulum lorem convallis. Integer dapibus sodales mi, vitae dapibus neque maximus a. Vivamus magna nibh, finibus in turpis ac, finibus sagittis lorem. Ut dapibus nibh a ipsum blandit pellentesque. Integer dignissim tortor semper varius faucibus.', '370929', @LastId OUTPUT
EXEC dbo.DeviceInsert '358897070022394', 'Nokia 3310', 'Telenor', '1', '2017-03-08', 1, 1, '', '370929', @LastId OUTPUT
EXEC dbo.DeviceInsert '864582010431098', 'Nokia 3210', 'Telenor', '1', '2017-03-08', 2, 1, '', '370929', @LastId OUTPUT
EXEC dbo.DeviceInsert '355132073353254', 'Samsung Galaxy', 'Telenor', '1', '2017-03-08', 1, 4, '', '370929', @LastId OUTPUT
EXEC dbo.DeviceInsert '867989015112168', 'Apple iPhone 7', '3', '1', '2017-03-08', 1, 4, '', '370929', @LastId OUTPUT
EXEC dbo.DeviceInsert '355165061438570', 'Apple iPhone 6', '3', '1', '2017-03-08', 1, 4, '', '370929', @LastId OUTPUT
EXEC dbo.DeviceInsert '355403075028453', 'Apple iPhone 7', '3', '1', '2017-03-08', 1, 4, '', '370929', @LastId OUTPUT

EXEC dbo.QuotaInsert 'Mobilabonnement, Flatrate', '370929', @LastId OUTPUT
EXEC dbo.QuotaInsert 'Forbrugsafregnet abonnement', '370929', @LastId OUTPUT
EXEC dbo.QuotaInsert 'Mobilt bredbånd, Flatrate', '370929', @LastId OUTPUT

EXEC dbo.DataPlanInsert '3GB pr. måned (standard)', '370929', @LastId OUTPUT
EXEC dbo.DataPlanInsert '+7GB pr. måned', '370929', @LastId OUTPUT
EXEC dbo.DataPlanInsert '+17GB pr. måned', '370929', @LastId OUTPUT
EXEC dbo.DataPlanInsert '+47GB pr. måned', '370929', @LastId OUTPUT
EXEC dbo.DataPlanInsert '+1000GB pr. måned', '370929', @LastId OUTPUT

EXEC dbo.SimcardInsert '272222950151', '22222222', '41729296', 0, 1, 1, null, 1, '3', '1', '2017-03-08', 1, '', '370929', @LastId OUTPUT
EXEC dbo.SimcardInsert '221262625222', '22222222', '50857127', 0, 1, 1, null, 1, 'Telenor', '1', '2017-03-08', 3, '', '370929', @LastId OUTPUT
EXEC dbo.SimcardInsert '23126069727', '22222222', '93504581', 1, 1, 1, null, 1, 'Telenor', '1', '2017-03-08', 1, '', '370929', @LastId OUTPUT
EXEC dbo.SimcardInsert '26126439717', '22222222', '25554023', 0, 2, 1, null, 1, 'Telenor', '1', '2017-03-08', 1, '', '370929', @LastId OUTPUT
EXEC dbo.SimcardInsert '26126438990', '22222222', '93504572', 1, 0, 1, null, 1, 'Telenor', '1', '2017-03-08', 1, '', '370929', @LastId OUTPUT
EXEC dbo.SimcardInsert '28126516841', '22222222', '40576499', 0, 3, 1, null, 1, 'Telenor', '1', '2017-03-08', 1, '', '370929', @LastId OUTPUT
EXEC dbo.SimcardInsert '26126341368', '22222222', '41778921', 0, 0, 1, null, 1, '3', '1', '2017-03-08', 1, '', '370929', @LastId OUTPUT

EXEC dbo.EmployeeInsert '370929', 'TRR-IT07', 'Stiig Andreas Gade', 0, '', '370929', @LastId OUTPUT
EXEC dbo.EmployeeInsert '187087', 'TRR-MP103', 'Peter Petersen', 0, '', '370929', @LastId OUTPUT
EXEC dbo.EmployeeInsert '382660', 'TRR-MP113', 'Niels Nielsen', 0, '', '370929', @LastId OUTPUT
EXEC dbo.EmployeeInsert '164361', 'TRR-FBS03', 'Tom Thomas Thomsen', 0, '', '370929', @LastId OUTPUT
EXEC dbo.EmployeeInsert '180062', 'TRR-4100I', 'Pia Piasen', 0, '', '370929', @LastId OUTPUT
EXEC dbo.EmployeeInsert '423109', 'TRR-1SU1J', 'Trine Trinesen', 0, '', '370929', @LastId OUTPUT
EXEC dbo.EmployeeInsert '161645', 'TRR-MPSTNCH', 'Jack Jacksen', 0, '', '370929', @LastId OUTPUT

EXEC dbo.OrderInsert 3, 1, 3, '370929', 'TRR-IT07', 'Stiig Gade', 4, '', '370929'
EXEC dbo.OrderInsert 3, 1, 3, '370929', 'TRR-IT07', 'Stiig Gade', 4, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec efficitur aliquam risus in tristique. Curabitur lacinia pellentesque urna sit amet ultricies. Phasellus sed felis sollicitudin, ultricies velit sed, porta libero. Cras vehicula odio vitae sem dignissim, sit amet vestibulum sapien ultricies. Curabitur commodo ex condimentum orci lacinia, eu vestibulum lorem convallis. Integer dapibus sodales mi, vitae dapibus neque maximus a. Vivamus magna nibh, finibus in turpis ac, finibus sagittis lorem. Ut dapibus nibh a ipsum blandit pellentesque. Integer dignissim tortor semper varius faucibus.', '370929'
EXEC dbo.OrderInsert 3, 1, null, null, null, null, 1, '', '370929'
EXEC dbo.OrderInsert 4, 1, 1, '370929', 'TRR-IT07', 'Stiig Gade', 9, '', '370929'