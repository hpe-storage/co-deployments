{{/* vim: set filetype=mustache: */}}

{{/*
memToBytes parses a Kubernetes memory quantity (e.g. "1Gi", "512Mi", "268435456")
into an integer number of bytes. Supports binary (Ki/Mi/Gi/Ti) and decimal
(K/M/G/T) suffixes, or a plain byte count.
*/}}
{{- define "hpe-csi-driver.memToBytes" -}}
{{- $q := . | toString | trim -}}
{{- if hasSuffix "Gi" $q -}}
{{- mul (trimSuffix "Gi" $q | int64) 1073741824 -}}
{{- else if hasSuffix "Mi" $q -}}
{{- mul (trimSuffix "Mi" $q | int64) 1048576 -}}
{{- else if hasSuffix "Ki" $q -}}
{{- mul (trimSuffix "Ki" $q | int64) 1024 -}}
{{- else if hasSuffix "Ti" $q -}}
{{- mul (trimSuffix "Ti" $q | int64) 1099511627776 -}}
{{- else if hasSuffix "G" $q -}}
{{- mul (trimSuffix "G" $q | int64) 1000000000 -}}
{{- else if hasSuffix "M" $q -}}
{{- mul (trimSuffix "M" $q | int64) 1000000 -}}
{{- else if hasSuffix "K" $q -}}
{{- mul (trimSuffix "K" $q | int64) 1000 -}}
{{- else if hasSuffix "T" $q -}}
{{- mul (trimSuffix "T" $q | int64) 1000000000000 -}}
{{- else -}}
{{- $q | int64 -}}
{{- end -}}
{{- end -}}

{{/*
goRuntimeEnv renders optional Go runtime env vars for a long-running HPE Go
container (ESC-17696: THP + MADV_FREE memory bloat). Call with a dict:
  (dict "root" $ "resources" <component .resources>)
- GODEBUG is emitted when .Values.goDebug is set.
- GOMEMLIMIT is emitted when .Values.goMemLimitPercent is > 0 and the container
  has a limits.memory; it is computed as that percentage of the memory limit
  (in bytes) so the Go GC runs before the container hard limit is reached.
The caller is responsible for placement/indentation (pipe through nindent).
*/}}
{{- define "hpe-csi-driver.goRuntimeEnv" -}}
{{- $root := .root -}}
{{- $entries := list -}}
{{- if $root.Values.goDebug -}}
{{- $entries = append $entries (printf "- name: GODEBUG\n  value: %q" (toString $root.Values.goDebug)) -}}
{{- end -}}
{{- $mem := "" -}}
{{- with .resources -}}{{- with .limits -}}{{- $mem = .memory -}}{{- end -}}{{- end -}}
{{- if and $root.Values.goMemLimitPercent $mem -}}
{{- $bytes := include "hpe-csi-driver.memToBytes" $mem | int64 -}}
{{- $limit := div (mul $bytes ($root.Values.goMemLimitPercent | int64)) 100 -}}
{{- $entries = append $entries (printf "- name: GOMEMLIMIT\n  value: %q" (printf "%d" $limit)) -}}
{{- end -}}
{{- join "\n" $entries -}}
{{- end -}}
{{/*
Expand the name of the chart.
*/}}
{{- define "hpe-csi-storage.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hpe-csi-storage.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hpe-csi-storage.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
CHAP secret validation
*/}}
{{- define "hpe-csi-storage.chapSecretValidation" -}}
{{- if not (empty .Values.iscsi.chapSecretName) }}
  {{- $secret := lookup "v1" "Secret" .Release.Namespace .Values.iscsi.chapSecretName }}
  {{- if not $secret }}
    {{- fail (printf "Secret %s not found in namespace %s" .Values.iscsi.chapSecretName .Release.Namespace) }}
  {{- end }}

  {{- $username := index $secret.data "chapUser" | b64dec }}
  {{- $password := index $secret.data "chapPassword" | b64dec }}

  {{- if or (empty $username) (empty $password) }}
    {{- fail "Username or password cannot be empty." }}
  {{- end }}

  {{- $chapUserValidationPattern := "^[a-zA-Z0-9][a-zA-Z0-9\\-:.]{0,63}$" }}
  {{- $chapPasswordValidationPattern := "^[a-zA-Z0-9!#$%()*+,-./:<>?@_{}|~]{12,16}$" }}

   {{- if not (regexMatch $chapUserValidationPattern $username) }}
    {{- fail (printf "Username does not match the required pattern: %s" $chapUserValidationPattern) }}
  {{- end }}

  {{- if not (regexMatch $chapPasswordValidationPattern $password) }}
    {{- fail (printf "Password does not match the required pattern: %s" $chapPasswordValidationPattern) }}
  {{- end }}

{{- end }}
{{- end -}}

{{- define "empty" -}}
{{- eq . "" -}}
{{- end -}}
