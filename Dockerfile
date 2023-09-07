FROM nginx
ADD /home/ubuntu/web/* /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
