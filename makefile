include $(PQ_FACTORY)/factory.mk

pq_part_name := nginx-1.7.10
pq_part_file := $(pq_part_name).tar.gz

pq_zlib_part_name := zlib-1.2.8
pq_zlib_part_file := $(pq_zlib_part_name).tar.gz

pq_pcre_part_name := pcre-8.36
pq_pcre_part_file := $(pq_pcre_part_name).tar.gz

pq_ngx_postgres_name := ngx_postgres-1.0rc5
pq_ngx_postgres_file := $(pq_ngx_postgres_name).tar.gz

pq_ngx_coolkit_name := ngx_coolkit-0.2rc2
pq_ngx_coolkit_file := $(pq_ngx_coolkit_name).tar.gz

pq_ngx_auth_request_name := ngx_http_auth_request_module-662785733552
pq_ngx_auth_request_file := $(pq_ngx_auth_request_name).tar.gz

pq_nginx_configuration_flags += --prefix=$(part_dir)
pq_nginx_configuration_flags += --with-pcre=../$(pq_pcre_part_name)
pq_nginx_configuration_flags += --with-zlib=../$(pq_zlib_part_name)
pq_nginx_configuration_flags += --with-http_ssl_module
pq_nginx_configuration_flags += --with-ld-opt="-L $(pq-openssl-dir)/lib"
pg_nginx_configuration_flags += --with-ld-opt="-L $(pq-postgresql-dir)/lib"
pq_nginx_configuration_flags += --add-module=../$(pq_ngx_postgres_name)
pq_nginx_configuration_flags += --add-module=../$(pq_ngx_coolkit_name)
pq_nginx_configuration_flags += --add-module=../$(pq_ngx_auth_request_name)


build-stamp: stage-stamp
	$(MAKE) -C $(pq_part_name) mkinstalldirs=$(part_dir)
	$(MAKE) -C $(pq_part_name) mkinstalldirs=$(part_dir) DESTDIR=$(stage_dir) install
	touch $@

stage-stamp: configure-stamp

configure-stamp: patch-stamp
	cd $(pq_part_name) && ./configure $(pq_nginx_configuration_flags)
	touch $@

patch-stamp: unpack-stamp
	touch $@

unpack-stamp: $(pq_part_file)
	tar xf $(source_dir)/$(pq_part_file)
	tar xf $(source_dir)/$(pq_pcre_part_file)
	tar xf $(source_dir)/$(pq_zlib_part_file)
	tar xf $(source_dir)/$(pq_ngx_postgres_file)
	tar xf $(source_dir)/$(pq_ngx_coolkit_file)
	tar xf $(source_dir)/$(pq_ngx_auth_request_file)
	touch $@
