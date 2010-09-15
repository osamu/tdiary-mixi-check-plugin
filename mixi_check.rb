#-*- coding : utf-8 -*-
#  mixi_check.rb 
#
#  Append mixi check links to each diary 
#
#  Copyright(C) Osamu MATSUMOTO
#

@weather_plugin_name ='mixi_check'

# configuration text
def configure_mixi_check_html
  <<-HTML
<h3 class=subtitle>Configure Mixi Plugin </h3>
<p>API Key
HTML
end

def configure_mixi_check
  if(@mode=='saveconf' ) then
    @conf['mixi_check.key'] = @cgi.params['mixi_check.key'][0]
  end
  configure_mixi_check_html(@conf)
end

def create_mixi_check_link(url)
  
end

# add handler 
add_conf_proc ( 'mixi_check', @mixi_check_plugin_name ) do configure_mixi_check end
add_header_proc do header_mixi_check end
add_title_proc do |date,title| 
  title + create_mixi_check_link(@conf, url)
end
