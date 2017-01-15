// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>    
// License : LGPL V3.0

subdemolist = ["", ".sce"];

subdemolist(:,2) = get_absolute_file_path("carrier-rec.dem.gateway.sce") + subdemolist(:,2);

