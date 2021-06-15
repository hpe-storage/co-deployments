/*
Copyright 2021.

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

// HPECSIDriverSpec defines the desired state of HPECSIDriver
type HPECSIDriverSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
	// Important: Run "make" to regenerate code after modifying this file
	// Control CSP Service and Deployments for HPE storage products
	Disable DisableInfo `json:"disable"`
	// Image Pull Policy for HPE CSI driver images
	ImagePullPolicy string `json:"imagePullPolicy"`
	// Default logLevel for HPE CSI driver deployments
	LogLevel string `json:"logLevel"`
	// DisableNodeConformance disables automatic installation of iscsi/multipath packages
	DisableNodeConformance bool `json:"disableNodeConformance"`
	// Iscsi parameters to be configured
	Iscsi IscsiInfo `json:"iscsi"`
	// Registry prefix for CSI driver images
	Registry string `json:"registry"`
	// Kubelet root directory path
	KubeletRootDir string `json:"kubeletRootDir"`
	// DisableNodeGetVolumeStats will be called by default, set true to disable the call
	DisableNodeGetVolumeStats string `json:"disableNodeGetVolumeStats"`
	// CSP client timeout for HPE Alletra 9000, Primera and 3PAR (60-360 seconds)
	CspClientTimeout string `json:"cspClientTimeout"`
}

// DisableInfo defines different CSP services which can be disabled
type DisableInfo struct {
	Nimble      string `json:"nimble"`
	Primera     string `json:"primera"`
	Alletra6000 string `json:"alletra6000"`
	Alletra9000 string `json:"alletra9000"`
}

// IscsiInfo defines different Iscsi parameters which can be configured
type IscsiInfo struct {
	ChapUser     string `json:"chapUser"`
	ChapPassword string `json:"chapPassword"`
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

// HPECSIDriverStatus defines the observed state of HPECSIDriver
type HPECSIDriverStatus struct {
	// HPE CSI Driver helm release status
	Conditions []HelmAppCondition `json:"conditions"`
	// HPE CSI Driver helm release
	DeployedRelease *HelmAppRelease `json:"deployedRelease,omitempty"`
}

//+kubebuilder:object:root=true
//+kubebuilder:subresource:status

// HPECSIDriver is the Schema for the hpecsidrivers API
type HPECSIDriver struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   HPECSIDriverSpec   `json:"spec,omitempty"`
	Status HPECSIDriverStatus `json:"status,omitempty"`
}

//+kubebuilder:object:root=true

// HPECSIDriverList contains a list of HPECSIDriver
type HPECSIDriverList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []HPECSIDriver `json:"items"`
}

func init() {
	SchemeBuilder.Register(&HPECSIDriver{}, &HPECSIDriverList{})
}
