module ProjectHelper
  def format_target_list( project )
    result = ""
    result += "<ul>\n"
    if @project.has_element? :target
      @project.each_target do |target|
        result += "<li><b>#{target.platform.name}</b>\n"
        result += format_arch_list( target )
        result += "</li>\n"
      end
    end
    result += "</ul>\n"
  end

  def format_arch_list( target )
    result = ""
    if target.has_element? :arch
      result += "<ul>\n"
      target.each_arch do |arch|
        result += "<li>#{arch}</li>\n"
      end
      result += "</ul>\n"
    end
  end

  def status_for( repo, arch, package )
    @statushash[repo][arch][package] || ActiveXML::Node.new("<status code='unknown' package='#{package}'/>")
  end

  def status_id_for( repo, arch, package )
    "#{package}:#{repo}:#{arch}"
  end

  def watch_link_text
    if @user
      @user.watches?(@project_name) ? "[Don't watch this project]" : "[Watch this project]"
    end
  end

  def format_packstatus_for( repo, arch )
    return if @buildresult.nil?
    return unless @buildresult.has_element? :result
    ret = String.new
    
    result = @buildresult.result("@repository='#{repo}' and @arch='#{arch}'")
    if result.nil?
      ret << "n/a<br>"
    else
      result.summary.each_statuscount do |scnt|
        ret << "#{scnt.code}:&nbsp;#{scnt.count}<br>\n"
      end
    end

    return ret
  end

  def simple_repo_button_to( label, opt={} )
    defaults = {
      :arch => [],
      :project => @project,
      :action => :save_target
    }
    opt = defaults.merge opt

    btn_to_opt = {
      :targetname => opt[:reponame],
      :platform => opt[:repo],
      :project => opt[:project],
      :action => opt[:action]
    }

    opt[:arch].each do |arch|
      btn_to_opt["arch[#{arch}]"] = ""
    end

    button_to label, btn_to_opt
  end

  def novell_bugzilla_url(user)
    "https://bugzilla.novell.com/enter_bug.cgi?classification=7340&product=openSUSE.org&component=3rd%20party%20software&assigned_to=#{user}"
  end
end
