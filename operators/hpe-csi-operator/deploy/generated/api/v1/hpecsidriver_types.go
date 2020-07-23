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
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// HPECSIDriverSpec defines the desired state of HPECSIDriver
type HPECSIDriverSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
	// Important: Run "make" to regenerate code after modifying this file

	// Image Pull Policy for HPE CSI driver images
	ImagePullPolicy string `json:"imagePullPolicy"`
	// Flavor of the CO orchestrator
	Flavor string `json:"flavor"`
	// Default logLevel for HPE CSI driver deployments
	LogLevel string `json:"logLevel"`
	// Backends list [nimble, primera3par] for the CSP deployment
	Backends   []string         `json:"backends"`
	Node       NodePlugin       `json:"node"`
	Controller ControllerPlugin `json:"controller"`
	Csp        CSPPlugin        `json:"csp"`
}

// NodePlugin defines configuration of HPE CSI node plugin
type NodePlugin struct {
	// Node selector to control the selection of nodes (optional)
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors=true
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.displayName="Node Selector"
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.x-descriptors="urn:alm:descriptor:com.tectonic.ui:selector:Node"
	NodeSelector map[string]string `json:"nodeSelector,omitempty"`

	// Optional: set tolerations for the node plugin pods
	// +listType=set
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors=true
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.displayName="Tolerations"
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.x-descriptors="urn:alm:descriptor:com.tectonic.ui:advanced,urn:alm:descriptor:io.kubernetes:Tolerations"
	Tolerations []corev1.Toleration `json:"tolerations,omitempty"`
	// Termination grace period for node plugin (optional)
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors=true
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.displayName="Termination Grace Period(Seconds)"
	TerminationGracePeriodSeconds *int32 `json:"terminationGracePeriodSeconds,omitempty"`
	// Node affinity for node plugin (optional)
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors=true
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.displayName="Node affinity"
	Affinity *corev1.Affinity `json:"affinity,omitempty"`
	// DisableNodeConformance disables automatic installation of iscsi/multipath packages
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors=true
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.displayName="Disable automatic installation of iscsi/multipath packages"
	DisableNodeConformance bool `json:"disableNodeConformance"`
	// Iscsi parameters to be configured
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors=true
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.displayName="iSCSI settings for node"
	Iscsi *IscsiInfo `json:"iscsi,omitempty"`
}

// ControllerPlugin defines configuration of HPE CSI controller plugin
type ControllerPlugin struct {
	// Node selector to control the selection of nodes (optional)
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors=true
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.displayName="Node Selector"
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.x-descriptors="urn:alm:descriptor:com.tectonic.ui:selector:Node"
	NodeSelector map[string]string `json:"nodeSelector,omitempty"`

	// Optional: set tolerations for the controller plugin pods
	// +listType=set
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors=true
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.displayName="Tolerations"
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.x-descriptors="urn:alm:descriptor:com.tectonic.ui:advanced,urn:alm:descriptor:io.kubernetes:Tolerations"
	Tolerations []corev1.Toleration `json:"tolerations,omitempty"`

	// Termination grace period for controller plugin (optional)
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors=true
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.displayName="Termination Grace Period(Seconds)"
	TerminationGracePeriodSeconds *int64 `json:"terminationGracePeriodSeconds,omitempty"`

	// Node affinity for controller plugin (optional)
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors=true
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.displayName="Node affinity"
	Affinity *corev1.Affinity `json:"affinity,omitempty"`
}

// CSPPlugin defines configuration of HPE ContainerStorageProvider(CSP)
type CSPPlugin struct {
	// Node selector to control the selection of nodes (optional)
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors=true
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.displayName="CSP Pod Node Selector"
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.x-descriptors="urn:alm:descriptor:com.tectonic.ui:selector:Node"
	NodeSelector map[string]string `json:"nodeSelector,omitempty"`

	// Set tolerations for the csp pods (optional)
	// +listType=set
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors=true
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.displayName="CSP Pod Tolerations"
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.x-descriptors="urn:alm:descriptor:com.tectonic.ui:advanced,urn:alm:descriptor:io.kubernetes:Tolerations"
	Tolerations []corev1.Toleration `json:"tolerations,omitempty"`

	// Termination grace period for csp plugin (optional)
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors=true
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.displayName="Termination Grace Period(Seconds)"
	TerminationGracePeriodSeconds *int64 `json:"terminationGracePeriodSeconds,omitempty"`

	// Node affinity for CSP (optional)
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors=true
	// +operator-sdk:gen-csv:customresourcedefinitions.specDescriptors.displayName="Node affinity"
	Affinity *corev1.Affinity `json:"affinity,omitempty"`
}

// IscsiInfo defines different Iscsi parameters which can be configured
type IscsiInfo struct {
	ChapUser     *string `json:"chapUser,omitempty"`
	ChapPassword *string `json:"chapPassword,omitempty"`
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
