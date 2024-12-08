# test-goreleaser

## Verify binary

```shell
cosign verify-blob \
  --signature test-goreleaser_0.5.0_checksums.txt.sig \
  --certificate test-goreleaser_0.5.0_checksums.txt.pem \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  --certificate-identity https://github.com/tmknom/test-goreleaser/.github/workflows/release.yml@refs/heads/main \
  test-goreleaser_0.5.0_checksums.txt
```

## Verify binary attestation

```shell
gh attestation verify test-goreleaser_0.5.0_checksums.txt \
  --deny-self-hosted-runners \
  --repo tmknom/test-goreleaser \
  --cert-oidc-issuer https://token.actions.githubusercontent.com \
  --cert-identity https://github.com/tmknom/test-goreleaser/.github/workflows/release.yml@refs/heads/main
```

## Verify container image

```shell
cosign verify \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  --certificate-identity https://github.com/tmknom/test-goreleaser/.github/workflows/release.yml@refs/heads/main \
  ghcr.io/tmknom/test-goreleaser:latest
```

## Verify container image attestation

```shell
gh attestation verify oci://ghcr.io/tmknom/test-goreleaser:latest \
  --deny-self-hosted-runners \
  --repo tmknom/test-goreleaser \
  --cert-oidc-issuer https://token.actions.githubusercontent.com \
  --cert-identity https://github.com/tmknom/test-goreleaser/.github/workflows/release.yml@refs/heads/main
```
