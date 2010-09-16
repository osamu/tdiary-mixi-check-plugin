#-*- coding : utf-8 -*-
#  mixi_check.rb 
#
#  Append mixi check links to each diary 
#
#  Copyright(C) Osamu MATSUMOTO
#

@plugin_name ='mixi_check'

# configuration text
def option_html(value, default)
  "<option value=\"#{value}\" #{"selected" if value==default }>"
end
def radio_html(name, value, default)
  "<input name=\"#{name}\" value=\"#{value}\" type=\"radio\" #{'checked' if value==default}>"
end

def configure_mixi_check_html(conf)
  <<-HTML
<h2 class="subtitle">mixi check Plugin </h2>
<p>各日記のエントリにmixi checkのリンクを付けます。
<h4>mixiチェックキー</h4>
<p><a href="https://sap.mixi.jp">Developer Dashboard</a>のmixi Pluginのメニュー
から、サービスを登録してください。tDiaryの設置されているページのURLをサービスのURLとして、
サービスアイコン、定型文を適宜選択します。
登録後、認証情報の部分に表示されるキーを入力してください。</p> 
<p><input name="mixi_check.key" size=50 value="#{conf['mixi_check.key']}">

<h4>サービスのURL</h4>
<P>上記、mixi Pluginサービスとして登録した際のURL
<P><input name="mixi_check.url" size=50 value="#{conf['mixi_check.url']}">


<h4>表示する場所</h4>
<p>下記から選んでください。</p> 
<p><select name="mixi_check.position" >
#{option_html('title', conf['mixi_check.position'])} タイトル 
#{option_html('subtitle', conf['mixi_check.position'])} サブタイトル 
</select>

<h4>チェックアイコン</h4>
<p>表示するアイコンを選択してください #{conf['mixi_check.button']}
<ul style="margin-left:-3em;list-style-type:none;">
<li>#{radio_html("mixi_check.button",'button-1',conf['mixi_check.button'])}
<img src="http://img.mixi.jp/img/basic/mixicheck_entry/bt_check_1.png" alt="" /> 
<li>#{radio_html("mixi_check.button",'button-2',conf['mixi_check.button'])}
<img src="http://img.mixi.jp/img/basic/mixicheck_entry/bt_check_2.png" alt="" /> 
<li>#{radio_html("mixi_check.button",'button-3',conf['mixi_check.button'])}
<img src="http://img.mixi.jp/img/basic/mixicheck_entry/bt_check_3.png" alt="" />
<li>#{radio_html("mixi_check.button",'button-4',conf['mixi_check.button'])}
<img src="http://img.mixi.jp/img/basic/mixicheck_entry/bt_check_4.png" alt="" />
<li>#{radio_html("mixi_check.button",'button-5',conf['mixi_check.button'])}
<img src="http://img.mixi.jp/img/basic/mixicheck_entry/bt_check_5.png" alt="" />
</ul>
HTML

end

def configure_mixi_check
  if(@mode=='saveconf' ) then
    @conf['mixi_check.key'] = @cgi.params['mixi_check.key'][0] || ''
    @conf['mixi_check.url'] = @cgi.params['mixi_check.url'][0] || ''
    @conf['mixi_check.position'] = @cgi.params['mixi_check.position'][0] || 'title'
    @conf['mixi_check.button'] = @cgi.params['mixi_check.button'][0] ||'button-1'
  end
  configure_mixi_check_html(@conf)
end

def add_header_mixi_check
  "<script type=\"text/javascript\" src=\"http://static.mixi.jp/js/share.js\"></script>"
end

def create_mixi_check_link(conf, url)
  return "" if conf['mixi_check.key']==''
  <<-HTML
  <a href="http://mixi.jp/share.pl" class="mixi-check-button" data-key="#{conf['mixi_check.key']}" data-url="#{url}" data-button='#{conf['mixi_check.button']}'>Check</a>
HTML
end

add_footer_proc do
  <<-HTML
<script type="text/javascript" src="http://static.mixi.jp/js/share.js"></script>
HTML
end

add_conf_proc ( 'mixi_check', @plugin_name ,'etc') do 
  configure_mixi_check
end

case @conf['mixi_check.position']
  when /^title/
  add_title_proc do |date, title| 
    title + create_mixi_check_link(@conf, url)
  end

  when /^subtitle/
  add_subtitle_proc do |date, index, subtitle|
    url = "#{@conf['mixi_check.url']}#{@index}#{anchor( date.strftime( '%Y%m%d' ) + '#p' + sprintf( '%02d', index ))}"
    subtitle + create_mixi_check_link(@conf,url)
  end
end

