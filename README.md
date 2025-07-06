# Skynet Kubernetes Manifests & Infrastructure

This repository contains the Kubernetes manifests and infrastructure-as-code (IaC) resources for the Skynet Cyberdine System. The structure is organized to support modular, environment-specific, and scalable deployments using Kustomize and Terraform.

## Folder Structure Overview

```text
skynet-kubernetes-manifests/
├── apps/
│   └── monitoring/
│       ├── fluent-bit/
│       ├── grafana/
│       ├── grafana-iac/
│       ├── loki/
│       ├── loki-stack/
│       └── prometheus/
│   └── traefik/
├── bootstrap/
│   └── argo-cd/
│   └── cluster-resources/
├── projects/
├── talos-terraform/
```

## Folder Details & Relationships


### `apps/`

Contains application-level Kubernetes manifests, organized by component and further split into `base` (common configuration) and `overlays` (environment-specific customizations, e.g., `dev`).

- **monitoring/**: Monitoring stack components.
  - **fluent-bit/**: Log forwarder. Has `base` and `overlays/dev` for environment-specific configs.
  - **grafana/**: Visualization tool. Structured similarly.
  - **grafana-iac/**: IaC-managed Grafana resources.
  - **loki/**: Log aggregation. Includes persistent volume claims.
  - **loki-stack/**: Kustomize entrypoint for the Loki stack.
  - **prometheus/**: Metrics collection. Structured with `base` and `overlays/dev`.
- **traefik/**: Ingress controller. Contains RBAC, deployment, and service definitions, with overlays for environments.


### `bootstrap/`

Contains manifests for bootstrapping the cluster and core resources.

- **argo-cd.yaml**: Argo CD installation manifest.
- **cluster-resources.yaml**: Aggregates core namespaces and resources.
- **iac-grafana.yaml, loki-stack.yaml, traefik.yaml, root.yaml**: Entrypoints for bootstrapping key components.
- **argo-cd/**: Argo CD configuration (e.g., command params, kustomization).
- **cluster-resources/**: Namespaces and resources required for the cluster, including monitoring and traefik namespaces.


### `projects/`

Contains project-level configuration and documentation for different environments or teams (e.g., `dev.yaml`).


### `talos-terraform/`

Infrastructure-as-code for provisioning the underlying Kubernetes cluster using [Talos](https://www.talos.dev/) and [Terraform](https://www.terraform.io/). Includes main configuration, variables, and outputs.


## Relationships

- **`talos-terraform/`** provisions the Kubernetes cluster infrastructure.
- **`bootstrap/`** applies core resources and bootstraps Argo CD, which then manages the deployment of applications defined in `apps/`.
- **`apps/`** contains the actual application manifests, organized for Kustomize overlays to support multiple environments.
- **`projects/`** provides environment or team-specific configuration, referenced by Argo CD or other tools.


## Usage

1. **Provision Cluster**: Use `talos-terraform/` to create the Kubernetes cluster.
2. **Bootstrap Core Resources**: Apply manifests in `bootstrap/` to set up namespaces, Argo CD, and other essentials.
3. **Deploy Applications**: Argo CD (or manual `kubectl apply`) deploys resources from `apps/` using Kustomize overlays for the target environment.
4. **Manage Projects**: Use `projects/` for environment-specific or team-specific configuration.

---

For more details, see the README files within each subfolder.
