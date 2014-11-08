docker run -d -p 8080:8080 \
	-v ~/one-click-docker-registry/config:/etc/nginx/conf.d \
	--link registry:registry \
	nginx
