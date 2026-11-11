# CentOS Stream 10 cloud images

Cloud-init-ready, signed CentOS Stream 10 qcow2 images for OpenStack and Proxmox,
part of the [openimages.cloud](https://openimages.cloud) catalog.

- Catalog page: <https://openimages.cloud/images/centos-stream-10/>
- Registry: <https://images.openimages.cloud/centos-stream-10/latest/>

## About

CentOS Stream 10 is the continuously delivered distribution that tracks just ahead of RHEL 10, published by the CentOS Project
([https://www.centos.org/](https://www.centos.org/)). This repo takes the official upstream
GenericCloud image ([listing](https://cloud.centos.org/centos/10-stream/x86_64/images/)), verifies it against the
upstream SHA-256 checksum, applies the openimages.cloud cloud-init policy,
boot-tests it, signs it with cosign (keyless) and publishes it.

The build pipeline is shared with the rest of
[`open-img-cloud`](https://github.com/open-img-cloud): this repo only ships
`VERSION`, `build/customize.sh`, `build/detect-upstream.sh` and two thin
caller workflows that delegate to the reusable workflows in
[`open-img-cloud/.github`](https://github.com/open-img-cloud/.github).

## Lifecycle

CentOS Stream 10 is maintained until the end of RHEL 10 full support (expected 2030). New images are published weekly; like RHEL 10 it requires an **x86-64-v3** CPU (Haswell or newer).

## Image

- File: `centos-stream-<version>-x86_64.qcow2`, where `<version>` is
  the upstream compose id (e.g. `10-20261106.0`).
- Default user: `cloud-user` (SSH key from cloud-init, passwordless sudo).
- The root filesystem grows to the flavor disk on first boot.

## Use it

```sh
V=10-20261106.0
curl -fLO https://images.openimages.cloud/centos-stream-10/$V/centos-stream-$V-x86_64.qcow2

openstack image create \
    --disk-format qcow2 --container-format bare \
    --property hw_qemu_guest_agent=yes \
    --file centos-stream-$V-x86_64.qcow2 \
    'CentOS Stream 10 '$V
```

Verification (cosign), Proxmox commands and provenance details are on the
[catalog page](https://openimages.cloud/images/centos-stream-10/) and in the
[verification guide](https://openimages.cloud/verify/).

## Release flow

1. `watch.yml` runs daily (07:02 UTC) and opens an
   `auto/upstream-bump` pull request when upstream publishes a new image.
2. Merge it, then push the tag `v<VERSION>`: `release.yml` builds, boot-tests,
   signs and publishes the image.

## License

The build tooling in this repository is [GPL-2.0](LICENSE). The image keeps
the licensing terms of CentOS Stream. CentOS is a trademark of Red Hat, Inc. This project is not affiliated with it.
