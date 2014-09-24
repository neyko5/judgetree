class TreeController < ApplicationController
  def index
  	@total_judge_count=Judge.all.count
    @countries=Judge.where(:country_tree.ne =>"").distinct(:country_tree)
    @countries.sort!
    @counts=Array.new;
    @countries.each do |country|
    	@counts.push IsoCountryCodes.find(country)
    end
  end

  def show
  	@country=IsoCountryCodes.find(params[:id]);
  	@judge_count = Judge.where(country_tree: params[:id].upcase).count
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Name' )
    data_table.new_column('string', 'Parent')
    data_table.new_column('string', 'Tip')
    data_table.add_rows(Judge.where(country_tree: params[:id].upcase).asc(:name).collect{|j| [{
    	v: j.id.to_s,
    	f: createWindow(j)
    }, j.parent_judge.try(:id).try(:to_s), "#{j.name} (#{j.level})"]})

    @chart = GoogleVisualr::Interactive::OrgChart.new(data_table, {allowHtml: true})
  end

  def createWindow(j)
    @string="<div class='judge #{j.level_to_word}'><p>#{j.name_output}</p><img class='image-flag' src='/assets/flags/#{j.country}.png' title='#{IsoCountryCodes.find(j.country).name}' />";
    if(!j.l2_cert.blank? or !j.l3_cert.blank?)
      @class=""
      if(!j.l2_cert.blank? and !j.l3_cert.blank?)
        @class="big"
      end

      @string+="<div class='extra #{@class}'>"
      if(!j.l2_cert.blank?)
        @string+="<div class='certifier'><div class='cert-label'>#{t(:l2_certificator)}</div><div class='cert-name'>#{j.l2_cert}</div></div>";
      end

      if(!j.l3_cert.blank?)
        @string+="<div class='certifier'><div class='cert-label'>#{t(:l3_certificator)}</div><div class='cert-name'>#{j.l3_cert}</div></div>";
      end

      @string+="</div>"
    end

    @string+="<div class='level level-#{j.level_to_short}'>#{j.level_to_short}</div><img class='profile' src='http://apps.magicjudges.org/dci/avatar?dci=#{j.dci_number}&size=120' /></div>";

    return @string;
  end
end