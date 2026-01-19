#!/bin/bash
# Тестирование политик безопасности

echo "=== Testing Pod Security Policies ==="

# Test 1: Privileged pod should be rejected
echo -e "\n[TEST 1] Privileged pod..."
kubectl apply -f ../insecure-manifests/privileged-pod.yaml 2>&1 | grep -q "forbidden\|denied\|violated" && echo "PASS: Rejected" || echo "FAIL: Allowed"

# Test 2: Root pod should be rejected
echo -e "\n[TEST 2] Root user pod..."
kubectl apply -f ../insecure-manifests/root-pod.yaml 2>&1 | grep -q "forbidden\|denied\|violated" && echo "PASS: Rejected" || echo "FAIL: Allowed"

# Test 3: HostPath pod should be rejected
echo -e "\n[TEST 3] HostPath pod..."
kubectl apply -f ../insecure-manifests/hostpath-pod.yaml 2>&1 | grep -q "forbidden\|denied\|violated" && echo "PASS: Rejected" || echo "FAIL: Allowed"

# Test 4: Secure pod should be accepted
echo -e "\n[TEST 4] Secure pod..."
kubectl apply -f ../secure-manifests/secure-pod.yaml 2>&1 | grep -q "created\|configured" && echo "PASS: Accepted" || echo "FAIL: Rejected"

# Cleanup
kubectl delete -f ../secure-manifests/secure-pod.yaml --ignore-not-found

echo -e "\n=== Tests Complete ==="
