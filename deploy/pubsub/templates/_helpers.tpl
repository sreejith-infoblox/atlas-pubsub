{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pubsub.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pubsub.fullname" -}}
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
{{- define "pubsub.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "pubsub.labels" -}}
app.kubernetes.io/name: {{ include "pubsub.name" . }}
helm.sh/chart: {{ include "pubsub.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Container image reference.
When the cluster fact global.ib0.services.registry.host is set, the internal
registry host is prepended in front of the infobloxcto org (internal images
live at <registry-host>/infobloxcto/<name>). When it is empty, image.repository
is used as-is (Docker Hub by default). The registry host may itself be a
template string, so it is tpl'd. The tag defaults to the chart appVersion when
image.tag is empty.
*/}}
{{- define "pubsub.image" -}}
{{- $repo := .Values.image.repository -}}
{{- $host := tpl (((((.Values.global).ib0).services).registry).host | default "") . -}}
{{- if $host -}}
{{- $repo = printf "%s/infobloxcto" $host -}}
{{- end -}}
{{- printf "%s/%s:%s" $repo .Values.image.name (.Values.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
