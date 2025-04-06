.DEFAULT_GOAL := create

pre:
	@kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

	@kubectl wait --namespace metallb-system \
		--for=condition=ready pod \
		--selector=app=metallb \
		--timeout=120s

	@kubectl apply -f manifests/

helm:
	@helmfile apply
	
create: 
	@kind create cluster --config config.yaml

up: create pre helm

destroy:
	@kind delete clusters kind

passwd:
	@echo "Jenkins Admin Password:"
	@kubectl get secret -n jenkins jenkins -ojson | jq -r '.data."jenkins-admin-password"' | base64 -d

	@echo "ArgoCD Password:"
	@kubectl get secret -n argocd argocd-initial-admin-secret -ojson | jq -r '.data.password' | base64 -d

	@echo "Sonarqube Admin Password:"
	@echo Senha@123456
