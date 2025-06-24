# MetalLB Kubernetes Configuration

This project provides the necessary configurations and scripts to deploy MetalLB in a Kubernetes environment.

## Project Structure

- **manifests/**: Contains the Kubernetes manifests for deploying MetalLB.
  - **metallb-namespace.yaml**: Defines the namespace for MetalLB.
  - **metallb-deployment.yaml**: Describes the deployment specifications for MetalLB.
  - **metallb-configmap.yaml**: Contains the configuration for MetalLB, including Layer 2 or BGP settings.
  - **metallb-secret.yaml**: Defines secrets used by MetalLB for communication with other services.

- **scripts/**: Contains scripts to automate deployment.
  - **apply.sh**: Automates the application of Kubernetes manifests.

- **.gitignore**: Lists files and directories to be excluded from version control.

## Installation

1. Ensure you have a running Kubernetes cluster.
2. Clone this repository to your local machine.
3. Navigate to the project directory.
4. Apply the manifests using the provided script:

   ```bash
   ./scripts/apply.sh
   ```

## Configuration

- Modify the `metallb-configmap.yaml` file to adjust the IP address allocation settings according to your network requirements.
- Ensure that the secrets defined in `metallb-secret.yaml` are correctly set up for your environment.

## Usage

Once deployed, MetalLB will manage the allocation of IP addresses for your services in the specified namespace. You can verify the deployment by checking the status of the MetalLB pods in the Kubernetes dashboard or using `kubectl get pods -n metallb-system`.

## Contributing

Feel free to submit issues or pull requests to improve this project.