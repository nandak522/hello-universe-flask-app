{{/* vim: set filetype=mustache: */}}

{{/*
Renders nodeAffinity block in the manifests
*/}}
{{- define "app.podAntiAffinity" }}
nodeAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    nodeSelectorTerms:
    - matchExpressions:
      - key: HA
        operator: DoesNotExist
      - key: cron
        operator: DoesNotExist
{{- end }}

{{- define "app.affinity" }}
affinity:
  {{- if .nodeAffinityLabels }}
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        {{- range $index, $label := .nodeAffinityLabels }}
        - key: {{ $label.name }}
          operator: In
          values:
          - {{ $label.value }}
        {{- end }}
  {{- end }}
  {{- if .podAntiAffinity }}
  podAntiAffinity:
  {{- if eq .podAntiAffinity.type "required" }}
    requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchExpressions:
        {{- range $index, $label := .podAntiAffinity.labels }}
        - key: {{ $label.name }}
          operator: In
          values:
          - {{ $label.value }}
        {{- end }}
      topologyKey: kubernetes.io/hostname
    {{- end }}
    {{- if eq .podAntiAffinity.type "preferred" }}
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          {{- range $index, $label := .podAntiAffinity.labels }}
          - key: {{ $label.name }}
            operator: In
            values:
            - {{ $label.value }}
          {{- end }}
        topologyKey: kubernetes.io/hostname
    {{- end }}
  {{- end }}
{{- end -}}

{{- define "app.configmap" }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .name }}
  namespace: {{ .namespace }}
data:
{{- toYaml .data | nindent 2 }}
{{- end }}

{{/*
Renders secret based on the secrets.yaml
*/}}
{{- define "app.secret" -}}
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: {{ .secret.name }}
  namespace: {{ .namespace }}
data:
{{- if .secret.data -}}
{{- toYaml .secret.data | nindent 2 }}
{{- else if .secret.file }}
  {{- (.root.Files.Glob (printf "%s" .secret.file)).AsSecrets | nindent 2 }}
{{- end -}}
{{- end }}
