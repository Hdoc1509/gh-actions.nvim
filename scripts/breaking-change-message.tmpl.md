**_This release contains backwards-incompatible changes._** To avoid picking up
releases like this, you should set the exact version or use a version range
syntax that only accepts `{{ compatible_semver }}` upgrades, i.e.:

- `{{ version_lazy }}` for `lazy.nvim`. See `lazy.nvim` documentation about
  [spec versioning](https://lazy.folke.io/spec#spec-versioning) for more
  information.

  _NOTE: `X` is a placeholder for any number. Don't use is as a value._

- `{{ version_packer }}` for `packer.nvim`. See `packer.nvim` documentation
  about [specifying plugins](https://github.com/wbthomason/packer.nvim?tab=readme-ov-file#specifying-plugins)
  and [this Pull Request](https://github.com/wbthomason/packer.nvim/pull/809)
  for more information.

