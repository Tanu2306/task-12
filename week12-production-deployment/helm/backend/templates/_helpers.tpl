{{/*
helm/backend/templates/_helpers.tpl
─────────────────────────────────────────────────────────────────────────────
Named template helpers for the shop-backend chart.
─────────────────────────────────────────────────────────────────────────────
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "shop-backend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a fully-qualified name, truncated to 63 chars.
*/}}
{{- define "shop-backend.fullname" -}}
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
Chart label value.
*/}}
{{- define "shop-backend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels applied to every resource.
*/}}
{{- define "shop-backend.labels" -}}
helm.sh/chart: {{ include "shop-backend.chart" . }}
{{ include "shop-backend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels – must be stable across upgrades.
*/}}
{{- define "shop-backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "shop-backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Full image reference: repository:tag
Falls back to Chart.AppVersion when tag is empty.
*/}}
{{- define "shop-backend.image" -}}
{{ printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) }}
{{- end }}

{{/*
ServiceAccount name.
*/}}
{{- define "shop-backend.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "shop-backend.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Database Secret name.
Returns the existingSecret name if set, otherwise the chart-managed secret.
*/}}
{{- define "shop-backend.secretName" -}}
{{- if .Values.db.existingSecret }}
{{- .Values.db.existingSecret }}
{{- else }}
{{- printf "%s-db-secret" (include "shop-backend.fullname" .) }}
{{- end }}
{{- end }}
