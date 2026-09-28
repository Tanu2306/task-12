{{/*
helm/frontend/templates/_helpers.tpl
─────────────────────────────────────────────────────────────────────────────
Named template helpers for the shop-frontend chart.
─────────────────────────────────────────────────────────────────────────────
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "shop-frontend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully-qualified app name.
Truncate to 63 characters (Kubernetes label limit).
If fullnameOverride is set, use that directly.
*/}}
{{- define "shop-frontend.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Chart label value: "<chart-name>-<chart-version>"
*/}}
{{- define "shop-frontend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels applied to every resource.
*/}}
{{- define "shop-frontend.labels" -}}
helm.sh/chart: {{ include "shop-frontend.chart" . }}
{{ include "shop-frontend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels used by Deployment matchLabels and Service selector.
These must be stable – changing them recreates pods.
*/}}
{{- define "shop-frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "shop-frontend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Build the full image reference: repository:tag
*/}}
{{- define "shop-frontend.image" -}}
{{ printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) }}
{{- end }}

{{/*
ServiceAccount name (empty string disables custom SA).
*/}}
{{- define "shop-frontend.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "shop-frontend.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
