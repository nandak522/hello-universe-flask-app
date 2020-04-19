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

{{- define "app.requiredPodAntiAffinity" }}
podAntiAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchExpressions:
      - key: app
        operator: In
        values:
        - store
    topologyKey: "kubernetes.io/hostname"
{{- end }}

{{- define "app.preferredPodAntiAffinity" }}
podAntiAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchExpressions:
            - key: security
              operator: In
              values:
              - S2
          topologyKey: failure-domain.beta.kubernetes.io/zone
{{- end }}
