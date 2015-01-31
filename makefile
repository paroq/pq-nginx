include $(PQ_FACTORY)/factory.mk

pq_part_name := nginx-1.7.9
pq_part_file := $(pq_part_name).tar.gz

pq_zlib_part_name := zlib-1.2.8
pq_zlib_part_file := $(pq_zlib_part_name).tar.gz

pq_pcre_part_name := pcre-8.36
pq_pcre_part_file := $(pq_pcre_part_name).tar.gz

pq_nginx_configuration_flags += --prefix=$(part_dir)
pq_nginx_configuration_flags += --with-pcre=../$(pq_pcre_part_name)
pq_nginx_configuration_flags += --with-zlib=../$(pq_zlib_part_name)
pq_nginx_configuration_flags += --with-http_ssl_module
pq_nginx_configuration_flags += --with-ld-opt="-L$(pq-openssl-dir)/lib"

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
	touch $@
