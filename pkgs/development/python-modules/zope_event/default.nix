{ lib, stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zope.event";
  version = "4.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e76517f5b9b119acf37ca8819781db6c16ea433f7e2062c4afc2b6fbedb1330";
  };

  meta = with lib; {
    description = "An event publishing system";
    homepage = "https://pypi.python.org/pypi/zope.event";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
