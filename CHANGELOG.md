SpaceIndices.jl Changelog
=========================

Version 1.1.0
-------------

- ![Enhancement][badge-enhancement] We now use the Celestrak file `SW-All.csv` to obtain
  some space indices such as the F10.7, Ap, and Kp. We also removed the old files
  `fluxtable.txt` and `Kp_ap_Ap_SN_F107_since_1932.txt`. Notice that this modification **is
  not considered** to be breaking because all indices can be fetched using the same
  functions (API). (PR [#2][gh-pr-2]))
- ![Feature][badge-feature] We added some other indices available in `SW-All.csv`.
  (PR [#2][gh-pr-2]))

Version 1.0.0
-------------

- ![BREAKING][badge-breaking] We renamed all the API and initialization functions to improve
  name consistency. Now, only the function `space_index` is exported. All others must be
  accessed using `SpaceIndices.` prefix.
- ![Feature][badge-feature] We added the following space index sets: `JB2008` and `KpAp`.
- ![Enhancement][badge-enhancement] We now re-export the modules `OptionalData` and `Dates`.
- ![Enhancement][badge-enhancement] We remove the dependency on **Interpolations.jl**
  because we only require simple interpolation algorithms (1D-constant and linear). Hence,
  we could implement fast algorithms inside the package, reducing the loading time.

Version 0.1.0
-------------

- Initial version.
  - This version was based on the code in **SatelliteToolbox.jl**. However, many API changes
    were implemented.

[badge-breaking]: https://img.shields.io/badge/BREAKING-red.svg
[badge-deprecation]: https://img.shields.io/badge/Deprecation-orange.svg
[badge-feature]: https://img.shields.io/badge/Feature-green.svg
[badge-enhancement]: https://img.shields.io/badge/Enhancement-blue.svg
[badge-bugfix]: https://img.shields.io/badge/Bugfix-purple.svg
[badge-info]: https://img.shields.io/badge/Info-gray.svg

[gh-pr-2]: https://github.com/JuliaSpace/SpaceIndices.jl/pull/2
