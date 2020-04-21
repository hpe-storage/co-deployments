/*

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package v1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// HpecsidriverSpec defines the desired state of Hpecsidriver
type HPECSIDriverSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
	// Important: Run "make" to regenerate code after modifying this file

	// HPE Storage class controls
	StorageClass HPEStorageClass `json:"storageClass"`
	// HPE Secret controls
	Secret HPESecret `json:"secret"`
	// Image Pull Policy for HPE CSI driver images
	ImagePullPolicy string `json:"imagePullPolicy"`
	// Flavor of the CO orchestrator
	Flavor string `json:"flavor"`
	// Default logLevel for HPE CSI driver deployments
	LogLevel string `json:"logLevel"`
	// BackendType nimble/primera3par for the CSP deployment
	BackendType string `json:"backendType"`
}

// HPESecret defines HPE secret params
type HPESecret struct {
	// Create HPE secret after CSI driver deployment, default: true
	Create bool `json:"create"`

	// Username for storage backend
	Username string `json:"username"`
	// Password for storage backend
	Password string `json:"password"`
	// Storage backend IP
	Backend string `json:"backend"`
	// HPE CSP Service Port
	ServicePort string `json:"servicePort"`
}

// HPEStorageClass defines the behavior of HPE CSI Driver Operator for creation of default  storage class
type HPEStorageClass struct {
	// Indicates to create a storage class in the cluster, default: true
	Create bool `json:"create"`
	// Indicates to make storage class as default in the cluster, default: false
	DefaultClass bool `json:"defaultClass"`
	// Name of storage class to create for HPE
	Name string `json:"name"`
	// Allow volume expansion parameter for default  storage class
	AllowVolumeExpansion bool `json:"allowVolumeExpansion"`
	// HPE storage class parameters
	Parameters HPEStorageClassParameters `json:"parameters"`
}

// HPEStorageClassParameters defines HPE storage class parameters
type HPEStorageClassParameters struct {
	// Volume description parameter in default storage class
	VolumeDescription string `json:"volumeDescription"`
	// Access protocol for storage backend
	AccessProtocol string `json:"accessProtocol"`
	// Filesystem type for default storage class
	FsType string `json:"fsType"`
}

type HelmAppConditionType string
type ConditionStatus string
type HelmAppConditionReason string

type HelmAppCondition struct {
	Type    HelmAppConditionType   `json:"type"`
	Status  ConditionStatus        `json:"status"`
	Reason  HelmAppConditionReason `json:"reason,omitempty"`
	Message string                 `json:"message,omitempty"`

	LastTransitionTime metav1.Time `json:"lastTransitionTime,omitempty"`
}

type HelmAppRelease struct {
	Name     string `json:"name,omitempty"`
	Manifest string `json:"manifest,omitempty"`
}

// HpecsidriverStatus defines the observed state of Hpecsidriver
type HPECSIDriverStatus struct {
	// HPE CSI Driver helm release status
	Conditions []HelmAppCondition `json:"conditions"`
	// HPE CSI Driver helm release
	DeployedRelease *HelmAppRelease `json:"deployedRelease,omitempty"`
}

// +kubebuilder:object:root=true

// HPECSIDriver is the Schema for the hpecsidrivers API
type HPECSIDriver struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   HPECSIDriverSpec   `json:"spec,omitempty"`
	Status HPECSIDriverStatus `json:"status,omitempty"`
}

// +kubebuilder:object:root=true

// HPECSIDriverList contains a list of Hpecsidriver
type HPECSIDriverList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []HPECSIDriver `json:"items"`
}

func init() {
	SchemeBuilder.Register(&HPECSIDriver{}, &HPECSIDriverList{})
}
