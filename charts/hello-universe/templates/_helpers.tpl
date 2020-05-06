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
  name: {{ .configMap.name }}
  namespace: {{ .namespace }}
data:
{{- if .configMap.data -}}
{{- toYaml .configMap.data | nindent 2 }}
{{- else if .configMap.file }}
  {{- (.root.Files.Glob (printf "%s" .configMap.file)).AsConfig | nindent 2 }}
{{- end -}}
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

{{/*
Renders VolumeMounts for the Container in a Pod
*/}}
{{- define "app.containerVolumeMounts" -}}
{{- range $index, $volumeMountData := . -}}
{{- if and ($volumeMountData.file) ($volumeMountData.mountPath) }}
- mountPath: {{ $volumeMountData.mountPath }}
  subPath: {{ $volumeMountData.file }}
  name: {{ $volumeMountData.name }}
  readOnly: true
{{- end }}
{{- end }}
{{- end -}}

{{/*
Renders VolumeMounts for the Pod
*/}}
{{- define "app.podVolumes" -}}
{{- if eq .type "secrets" }}
{{- range .secrets -}}
- secret:
    secretName: {{ .name }}
  name: {{ .name }}
{{ end }}
{{- else -}}
{{- range .configMaps -}}
- configMap:
    name: {{ .name }}
  name: {{ .name }}
{{ end }}
{{- end -}}
{{- end -}}

{{/*
Renders Infra Configmap
*/}}
{{- define "app.infra-configmap" -}}
{{ $root := . }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .requiredInfraConfigs.name }}
  namespace: {{ .namespace }}
data:
  # Iterate on all required keys of .requiredInfraConfigs and
  # for each key, pull the value expression and
  # lookup that expression in .infraConfig values
  {{ range $configKey, $configValue := .requiredInfraConfigs.values }}
  {{- $configValue := trimPrefix "$" $configValue }}
  {{- $actualConfigValue := pluck $configValue $root.allInfraConfigs | first }}
  {{- $configKey -}}: {{$actualConfigValue | quote}}
  {{ end }}
{{ end }}
