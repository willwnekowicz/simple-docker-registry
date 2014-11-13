docker run -d -p 443:443 \
	-v ~/one-click-docker-registry/nginx/config:/etc/nginx/conf.d \
	--link registry:registry \
	registry-nginx
