# 1.0.0 (2026-09-14)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** default jumphost linux vm to disabled ([e9646f6](https://github.com/nluwv/AZLABS-showcase/commit/e9646f6f762d348ba0cb51b073d2cc2ac7f225f9))
* **ci:** include jumphost OTAP tfvars in repo ([b0b1ed7](https://github.com/nluwv/AZLABS-showcase/commit/b0b1ed70c9696846f083f62cae05acb8db599565))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **ci:** validate jumphost vm credentials and build tfvars ([df0f754](https://github.com/nluwv/AZLABS-showcase/commit/df0f75420b5ad87c665a5f3dfb526dea4fffd737))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **jumphost:** set alternate windows vm size for T environment ([4378270](https://github.com/nluwv/AZLABS-showcase/commit/437827060a289df16aadabd9c1d3e8961035bc22))
* **jumphost:** vendor module dependencies for CI ([df7e4cb](https://github.com/nluwv/AZLABS-showcase/commit/df7e4cb2adb3d7ba19cac38099161589f1a817fb))
* **terraform:** allow OTAP single-letter environment codes ([d249a90](https://github.com/nluwv/AZLABS-showcase/commit/d249a90889533314b6fb2da1320868808833dbe4))
* **terraform:** make encryption-at-host optional per vm ([dc18456](https://github.com/nluwv/AZLABS-showcase/commit/dc18456e48965023576600e7f65ba40617ce6212))
* **terraform:** nsg rule field mapping and windows hostname limit ([4ee7cfa](https://github.com/nluwv/AZLABS-showcase/commit/4ee7cfaff482b97554c329017693bd396c04c326))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))
* **terraform:** use replace regex for windows computer name ([c9ba480](https://github.com/nluwv/AZLABS-showcase/commit/c9ba480393c28b7101b01e105324b39795a29c54))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **ci:** auto-select next free jumphost instance ([77cafb0](https://github.com/nluwv/AZLABS-showcase/commit/77cafb07ad8d9b6189a50b31a990ddd54c7feabc))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-14)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** default jumphost linux vm to disabled ([e9646f6](https://github.com/nluwv/AZLABS-showcase/commit/e9646f6f762d348ba0cb51b073d2cc2ac7f225f9))
* **ci:** include jumphost OTAP tfvars in repo ([b0b1ed7](https://github.com/nluwv/AZLABS-showcase/commit/b0b1ed70c9696846f083f62cae05acb8db599565))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **ci:** validate jumphost vm credentials and build tfvars ([df0f754](https://github.com/nluwv/AZLABS-showcase/commit/df0f75420b5ad87c665a5f3dfb526dea4fffd737))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **jumphost:** vendor module dependencies for CI ([df7e4cb](https://github.com/nluwv/AZLABS-showcase/commit/df7e4cb2adb3d7ba19cac38099161589f1a817fb))
* **terraform:** allow OTAP single-letter environment codes ([d249a90](https://github.com/nluwv/AZLABS-showcase/commit/d249a90889533314b6fb2da1320868808833dbe4))
* **terraform:** make encryption-at-host optional per vm ([dc18456](https://github.com/nluwv/AZLABS-showcase/commit/dc18456e48965023576600e7f65ba40617ce6212))
* **terraform:** nsg rule field mapping and windows hostname limit ([4ee7cfa](https://github.com/nluwv/AZLABS-showcase/commit/4ee7cfaff482b97554c329017693bd396c04c326))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))
* **terraform:** use replace regex for windows computer name ([c9ba480](https://github.com/nluwv/AZLABS-showcase/commit/c9ba480393c28b7101b01e105324b39795a29c54))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **ci:** auto-select next free jumphost instance ([77cafb0](https://github.com/nluwv/AZLABS-showcase/commit/77cafb07ad8d9b6189a50b31a990ddd54c7feabc))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-14)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** default jumphost linux vm to disabled ([e9646f6](https://github.com/nluwv/AZLABS-showcase/commit/e9646f6f762d348ba0cb51b073d2cc2ac7f225f9))
* **ci:** include jumphost OTAP tfvars in repo ([b0b1ed7](https://github.com/nluwv/AZLABS-showcase/commit/b0b1ed70c9696846f083f62cae05acb8db599565))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **ci:** validate jumphost vm credentials and build tfvars ([df0f754](https://github.com/nluwv/AZLABS-showcase/commit/df0f75420b5ad87c665a5f3dfb526dea4fffd737))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **jumphost:** vendor module dependencies for CI ([df7e4cb](https://github.com/nluwv/AZLABS-showcase/commit/df7e4cb2adb3d7ba19cac38099161589f1a817fb))
* **terraform:** allow OTAP single-letter environment codes ([d249a90](https://github.com/nluwv/AZLABS-showcase/commit/d249a90889533314b6fb2da1320868808833dbe4))
* **terraform:** nsg rule field mapping and windows hostname limit ([4ee7cfa](https://github.com/nluwv/AZLABS-showcase/commit/4ee7cfaff482b97554c329017693bd396c04c326))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))
* **terraform:** use replace regex for windows computer name ([c9ba480](https://github.com/nluwv/AZLABS-showcase/commit/c9ba480393c28b7101b01e105324b39795a29c54))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **ci:** auto-select next free jumphost instance ([77cafb0](https://github.com/nluwv/AZLABS-showcase/commit/77cafb07ad8d9b6189a50b31a990ddd54c7feabc))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-14)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** default jumphost linux vm to disabled ([e9646f6](https://github.com/nluwv/AZLABS-showcase/commit/e9646f6f762d348ba0cb51b073d2cc2ac7f225f9))
* **ci:** include jumphost OTAP tfvars in repo ([b0b1ed7](https://github.com/nluwv/AZLABS-showcase/commit/b0b1ed70c9696846f083f62cae05acb8db599565))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **ci:** validate jumphost vm credentials and build tfvars ([df0f754](https://github.com/nluwv/AZLABS-showcase/commit/df0f75420b5ad87c665a5f3dfb526dea4fffd737))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **jumphost:** vendor module dependencies for CI ([df7e4cb](https://github.com/nluwv/AZLABS-showcase/commit/df7e4cb2adb3d7ba19cac38099161589f1a817fb))
* **terraform:** allow OTAP single-letter environment codes ([d249a90](https://github.com/nluwv/AZLABS-showcase/commit/d249a90889533314b6fb2da1320868808833dbe4))
* **terraform:** nsg rule field mapping and windows hostname limit ([4ee7cfa](https://github.com/nluwv/AZLABS-showcase/commit/4ee7cfaff482b97554c329017693bd396c04c326))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **ci:** auto-select next free jumphost instance ([77cafb0](https://github.com/nluwv/AZLABS-showcase/commit/77cafb07ad8d9b6189a50b31a990ddd54c7feabc))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-14)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** default jumphost linux vm to disabled ([e9646f6](https://github.com/nluwv/AZLABS-showcase/commit/e9646f6f762d348ba0cb51b073d2cc2ac7f225f9))
* **ci:** include jumphost OTAP tfvars in repo ([b0b1ed7](https://github.com/nluwv/AZLABS-showcase/commit/b0b1ed70c9696846f083f62cae05acb8db599565))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **ci:** validate jumphost vm credentials and build tfvars ([df0f754](https://github.com/nluwv/AZLABS-showcase/commit/df0f75420b5ad87c665a5f3dfb526dea4fffd737))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **jumphost:** vendor module dependencies for CI ([df7e4cb](https://github.com/nluwv/AZLABS-showcase/commit/df7e4cb2adb3d7ba19cac38099161589f1a817fb))
* **terraform:** allow OTAP single-letter environment codes ([d249a90](https://github.com/nluwv/AZLABS-showcase/commit/d249a90889533314b6fb2da1320868808833dbe4))
* **terraform:** nsg rule field mapping and windows hostname limit ([4ee7cfa](https://github.com/nluwv/AZLABS-showcase/commit/4ee7cfaff482b97554c329017693bd396c04c326))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **ci:** auto-select next free jumphost instance ([77cafb0](https://github.com/nluwv/AZLABS-showcase/commit/77cafb07ad8d9b6189a50b31a990ddd54c7feabc))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-14)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** default jumphost linux vm to disabled ([e9646f6](https://github.com/nluwv/AZLABS-showcase/commit/e9646f6f762d348ba0cb51b073d2cc2ac7f225f9))
* **ci:** include jumphost OTAP tfvars in repo ([b0b1ed7](https://github.com/nluwv/AZLABS-showcase/commit/b0b1ed70c9696846f083f62cae05acb8db599565))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **ci:** validate jumphost vm credentials and build tfvars ([df0f754](https://github.com/nluwv/AZLABS-showcase/commit/df0f75420b5ad87c665a5f3dfb526dea4fffd737))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **jumphost:** vendor module dependencies for CI ([df7e4cb](https://github.com/nluwv/AZLABS-showcase/commit/df7e4cb2adb3d7ba19cac38099161589f1a817fb))
* **terraform:** nsg rule field mapping and windows hostname limit ([4ee7cfa](https://github.com/nluwv/AZLABS-showcase/commit/4ee7cfaff482b97554c329017693bd396c04c326))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **ci:** auto-select next free jumphost instance ([77cafb0](https://github.com/nluwv/AZLABS-showcase/commit/77cafb07ad8d9b6189a50b31a990ddd54c7feabc))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-14)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** default jumphost linux vm to disabled ([e9646f6](https://github.com/nluwv/AZLABS-showcase/commit/e9646f6f762d348ba0cb51b073d2cc2ac7f225f9))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **ci:** validate jumphost vm credentials and build tfvars ([df0f754](https://github.com/nluwv/AZLABS-showcase/commit/df0f75420b5ad87c665a5f3dfb526dea4fffd737))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **jumphost:** vendor module dependencies for CI ([df7e4cb](https://github.com/nluwv/AZLABS-showcase/commit/df7e4cb2adb3d7ba19cac38099161589f1a817fb))
* **terraform:** nsg rule field mapping and windows hostname limit ([4ee7cfa](https://github.com/nluwv/AZLABS-showcase/commit/4ee7cfaff482b97554c329017693bd396c04c326))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **ci:** auto-select next free jumphost instance ([77cafb0](https://github.com/nluwv/AZLABS-showcase/commit/77cafb07ad8d9b6189a50b31a990ddd54c7feabc))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-14)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** default jumphost linux vm to disabled ([e9646f6](https://github.com/nluwv/AZLABS-showcase/commit/e9646f6f762d348ba0cb51b073d2cc2ac7f225f9))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **ci:** validate jumphost vm credentials and build tfvars ([df0f754](https://github.com/nluwv/AZLABS-showcase/commit/df0f75420b5ad87c665a5f3dfb526dea4fffd737))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **jumphost:** vendor module dependencies for CI ([df7e4cb](https://github.com/nluwv/AZLABS-showcase/commit/df7e4cb2adb3d7ba19cac38099161589f1a817fb))
* **terraform:** nsg rule field mapping and windows hostname limit ([4ee7cfa](https://github.com/nluwv/AZLABS-showcase/commit/4ee7cfaff482b97554c329017693bd396c04c326))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-14)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** default jumphost linux vm to disabled ([e9646f6](https://github.com/nluwv/AZLABS-showcase/commit/e9646f6f762d348ba0cb51b073d2cc2ac7f225f9))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **ci:** validate jumphost vm credentials and build tfvars ([df0f754](https://github.com/nluwv/AZLABS-showcase/commit/df0f75420b5ad87c665a5f3dfb526dea4fffd737))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **jumphost:** vendor module dependencies for CI ([df7e4cb](https://github.com/nluwv/AZLABS-showcase/commit/df7e4cb2adb3d7ba19cac38099161589f1a817fb))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-14)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** default jumphost linux vm to disabled ([e9646f6](https://github.com/nluwv/AZLABS-showcase/commit/e9646f6f762d348ba0cb51b073d2cc2ac7f225f9))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **ci:** validate jumphost vm credentials and build tfvars ([df0f754](https://github.com/nluwv/AZLABS-showcase/commit/df0f75420b5ad87c665a5f3dfb526dea4fffd737))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **jumphost:** vendor module dependencies for CI ([df7e4cb](https://github.com/nluwv/AZLABS-showcase/commit/df7e4cb2adb3d7ba19cac38099161589f1a817fb))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-14)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **ci:** validate jumphost vm credentials and build tfvars ([df0f754](https://github.com/nluwv/AZLABS-showcase/commit/df0f75420b5ad87c665a5f3dfb526dea4fffd737))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **jumphost:** vendor module dependencies for CI ([df7e4cb](https://github.com/nluwv/AZLABS-showcase/commit/df7e4cb2adb3d7ba19cac38099161589f1a817fb))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-14)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **jumphost:** vendor module dependencies for CI ([df7e4cb](https://github.com/nluwv/AZLABS-showcase/commit/df7e4cb2adb3d7ba19cac38099161589f1a817fb))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **jumphost:** vendor module dependencies for CI ([df7e4cb](https://github.com/nluwv/AZLABS-showcase/commit/df7e4cb2adb3d7ba19cac38099161589f1a817fb))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* add bootstrap substack and separate jumphost pipeline ([3a06bee](https://github.com/nluwv/AZLABS-showcase/commit/3a06beeba0b9280e63e6d54aa045f587c8747584))
* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** pass terraform vars to destroy ([190ee41](https://github.com/nluwv/AZLABS-showcase/commit/190ee414ad966e2864d7afba823a3254730ebb94))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** generate manifest with jq ([623a9c0](https://github.com/nluwv/AZLABS-showcase/commit/623a9c0f97b844e2285600812e6fb8ed53db91b9))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** let destroy resolve values from deployment manifest ([c7c5fc4](https://github.com/nluwv/AZLABS-showcase/commit/c7c5fc41e52809be121f02026470fd12e7ffe41a))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))
* **deploy:** persist manifest for destroy lookup ([7515b34](https://github.com/nluwv/AZLABS-showcase/commit/7515b34785a30a1419f17202eacd6efa1ec09798))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* **deploy:** add deploy or destroy mode with state artifact ([d207fb3](https://github.com/nluwv/AZLABS-showcase/commit/d207fb3a6f6ec743c9c8310624fcb751e2aab8fa))
* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))
* **terraform:** use Azure AD for storage data-plane operations ([800c050](https://github.com/nluwv/AZLABS-showcase/commit/800c05075b778a9f5a5327c807644f406ced140e))


### Features

* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))


### Features

* **deploy:** auto-select first free instance when RG exists ([a3653ea](https://github.com/nluwv/AZLABS-showcase/commit/a3653ea6c941461f5fe955b4413141fc0db76351))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** improve auth/env handling and avoid name collisions ([afdf615](https://github.com/nluwv/AZLABS-showcase/commit/afdf615a90d0e53c855f874de8fbf449bdce1c38))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** separate GitHub and Terraform environments ([1733fdc](https://github.com/nluwv/AZLABS-showcase/commit/1733fdc8e0ba9820104275246ad3891f038268e8))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** allow Azure OIDC credentials from secrets ([58acc22](https://github.com/nluwv/AZLABS-showcase/commit/58acc22abcdf08e6044c93d9f8d434988565c44b))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))
* **deploy:** support oidc or service-principal secret auth ([1a23d2f](https://github.com/nluwv/AZLABS-showcase/commit/1a23d2f1486ec7ab9ba23209726263988d75102a))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **checkov:** apply bootstrap policy exceptions and load config ([e8eedb7](https://github.com/nluwv/AZLABS-showcase/commit/e8eedb777e0c5e98c554bac44de67d478750d415))
* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))

# 1.0.0 (2026-09-11)


### Bug Fixes

* **ci:** run workflows from repository root ([bac0174](https://github.com/nluwv/AZLABS-showcase/commit/bac017487c1b4ff33e443c7280c3d65d01907646))

# 1.0.0 (2026-09-09)


### Features

* add bootstrap key vault ([a50f2aa](https://github.com/nluwv/AZLABS-cnc-azurerm-bootstrap-terraform-state/commit/a50f2aaa34417ca2a22d9c95b4e545da96c1ccfc))

# [0.1.0](https://github.com/jacquelinep777/xx-azurerm-bootstrap-terraform-state/compare/v0.0.1...v0.1.0) (2026-08-12)


### Features

* add bootstrap key vault ([a50f2aa](https://github.com/jacquelinep777/xx-azurerm-bootstrap-terraform-state/commit/a50f2aaa34417ca2a22d9c95b4e545da96c1ccfc))
