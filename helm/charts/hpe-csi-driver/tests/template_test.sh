#!/usr/bin/env bash
# Helm template/lint rendering assertions for hpe-csi-driver (CON-4960-5).
# Pure `helm lint`/`helm template` checks — no cluster required. Run from anywhere:
#   bash helm/charts/hpe-csi-driver/tests/template_test.sh
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHART_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

PASS=0
FAIL=0

pass() { PASS=$((PASS + 1)); echo "  [PASS] $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  [FAIL] $1"; }

# assert_count <description> <expected_count> <pattern> <template_selector> [extra helm args...]
assert_count() {
  local desc="$1" expected="$2" pattern="$3" selector="$4"
  shift 4
  local actual
  actual=$(helm template "${CHART_DIR}" -s "${selector}" "$@" 2>/dev/null | grep -c -- "${pattern}")
  if [[ "${actual}" -eq "${expected}" ]]; then
    pass "${desc} (expected ${expected}, got ${actual})"
  else
    fail "${desc} (expected ${expected}, got ${actual})"
  fi
}

echo "== helm lint (default values) =="
if helm lint "${CHART_DIR}" >/tmp/hpe-csi-driver-lint.log 2>&1; then
  pass "helm lint: default values"
else
  fail "helm lint: default values"
  cat /tmp/hpe-csi-driver-lint.log
fi

echo "== Scenario: 3-replica HA (chart default) =="
assert_count "controller Deployment renders replicas: 3" 1 "replicas: 3" templates/hpe-csi-controller.yaml
assert_count "all 7 leader-election-capable sidecars get --leader-election=true" 7 "leader-election=true" templates/hpe-csi-controller.yaml
assert_count "podAntiAffinity rendered" 1 "podAntiAffinity" templates/hpe-csi-controller.yaml
assert_count "podAntiAffinity is hard (requiredDuringScheduling)" 1 "requiredDuringSchedulingIgnoredDuringExecution" templates/hpe-csi-controller.yaml
assert_count "no soft (preferredDuringScheduling) podAntiAffinity" 0 "preferredDuringSchedulingIgnoredDuringExecution" templates/hpe-csi-controller.yaml
assert_count "topologySpreadConstraints rendered" 1 "topologySpreadConstraints" templates/hpe-csi-controller.yaml
assert_count "POD_NAMESPACE env rendered (hpe-csi-driver + csi-extensions)" 2 "POD_NAMESPACE" templates/hpe-csi-controller.yaml
assert_count "hpe-csi-driver podMonitor Lease timing env vars rendered" 3 "PODMONITOR_LEADER_ELECTION_" templates/hpe-csi-controller.yaml
assert_count "distributed dedup lock TTL env var rendered (hpe-csi-driver + csi-extensions)" 2 "DEDUP_LOCK_TTL" templates/hpe-csi-controller.yaml
assert_count "distributed dedup reaper interval env var rendered (hpe-csi-driver + csi-extensions)" 2 "DEDUP_REAPER_INTERVAL" templates/hpe-csi-controller.yaml
assert_count "controller rollout strategy maxUnavailable:1 rendered" 1 "maxUnavailable: 1" templates/hpe-csi-controller.yaml
assert_count "controller rollout strategy maxSurge:0 rendered" 1 "maxSurge: 0" templates/hpe-csi-controller.yaml

echo "== Scenario: 1-replica back-compat (--set controller.replicas=1) =="
assert_count "controller Deployment renders replicas: 1" 1 "replicas: 1" templates/hpe-csi-controller.yaml --set controller.replicas=1
assert_count "no --leader-election=true when replicas=1" 0 "leader-election=true" templates/hpe-csi-controller.yaml --set controller.replicas=1
assert_count "no podAntiAffinity when replicas=1" 0 "podAntiAffinity" templates/hpe-csi-controller.yaml --set controller.replicas=1
assert_count "POD_NAMESPACE still rendered at replicas=1, both containers (unconditional)" 2 "POD_NAMESPACE" templates/hpe-csi-controller.yaml --set controller.replicas=1
assert_count "hpe-csi-driver podMonitor Lease timing env vars still rendered at replicas=1 (unconditional)" 3 "PODMONITOR_LEADER_ELECTION_" templates/hpe-csi-controller.yaml --set controller.replicas=1
assert_count "distributed dedup env vars still rendered at replicas=1, both containers (unconditional)" 2 "DEDUP_LOCK_TTL" templates/hpe-csi-controller.yaml --set controller.replicas=1
assert_count "controller rollout strategy still rendered at replicas=1 (unconditional)" 1 "maxUnavailable: 1" templates/hpe-csi-controller.yaml --set controller.replicas=1

echo "== Scenario: nimble CSP on (chart default) =="
assert_count "nimble-csp Deployment rendered by default" 1 "^kind: Deployment$" templates/nimble-csp.yaml

echo "== Scenario: nimble CSP off (--set disable.nimble=true --set disable.alletra6000=true) =="
assert_count "nimble-csp Deployment absent when disabled" 0 "^kind: Deployment$" templates/nimble-csp.yaml --set disable.nimble=true --set disable.alletra6000=true

echo "== Scenario: CSP 3-replica HA (chart default) =="
assert_count "CSP Deployment renders replicas: 3" 1 "replicas: 3" templates/primera-3par-csp.yaml
assert_count "POD_NAMESPACE env rendered" 1 "POD_NAMESPACE" templates/primera-3par-csp.yaml
assert_count "CSP podAntiAffinity rendered" 1 "podAntiAffinity" templates/primera-3par-csp.yaml
assert_count "CSP podAntiAffinity is hard (requiredDuringScheduling)" 1 "requiredDuringSchedulingIgnoredDuringExecution" templates/primera-3par-csp.yaml
assert_count "CSP topologySpreadConstraints rendered" 1 "topologySpreadConstraints" templates/primera-3par-csp.yaml
assert_count "CSP livenessProbe rendered" 1 "livenessProbe" templates/primera-3par-csp.yaml
assert_count "CSP readinessProbe rendered" 1 "readinessProbe" templates/primera-3par-csp.yaml
assert_count "CSP PodDisruptionBudget rendered" 1 "kind: PodDisruptionBudget" templates/primera-3par-csp.yaml
assert_count "CSP rollout strategy maxUnavailable:1 rendered" 1 "maxUnavailable: 1" templates/primera-3par-csp.yaml
assert_count "CSP rollout strategy maxSurge:0 rendered" 1 "maxSurge: 0" templates/primera-3par-csp.yaml

echo "== Scenario: CSP 1-replica back-compat (--set csp.replicas=1) =="
assert_count "CSP Deployment renders replicas: 1" 1 "replicas: 1" templates/primera-3par-csp.yaml --set csp.replicas=1
assert_count "POD_NAMESPACE still rendered at replicas=1 (unconditional)" 1 "POD_NAMESPACE" templates/primera-3par-csp.yaml --set csp.replicas=1
assert_count "CSP probes still rendered at replicas=1 (unconditional)" 1 "livenessProbe" templates/primera-3par-csp.yaml --set csp.replicas=1
assert_count "no CSP podAntiAffinity when replicas=1" 0 "podAntiAffinity" templates/primera-3par-csp.yaml --set csp.replicas=1
assert_count "no CSP PodDisruptionBudget when replicas=1" 0 "kind: PodDisruptionBudget" templates/primera-3par-csp.yaml --set csp.replicas=1
assert_count "CSP rollout strategy still rendered at replicas=1 (unconditional)" 1 "maxUnavailable: 1" templates/primera-3par-csp.yaml --set csp.replicas=1

echo
echo "== Summary: ${PASS} passed, ${FAIL} failed =="
[[ "${FAIL}" -eq 0 ]]
