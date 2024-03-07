#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

class GetEstacioJob < ApplicationJob
  def perform
    get_admin
  end

  def get_admin
    # doc = Nokogiri::HTML(URI.open('https://portal.estacio.br/cursos/mestrado-e-doutorado/administra%C3%A7%C3%A3o-e-desenv-empresarial/disserta%C3%A7%C3%B5es/'))
    doc = Nokogiri::HTML(open('index.html'))

    array_content = []

    doc.css('.conteudo_simples').each do |row|
      data = {}
      data["year"] = row["rel"]

      posts = []
      post = {}
      evaluations = []
      rows = row.css('table tbody tr')

      if row["rel"].to_i <= 2017
        rows = row.css('table[border=1] > tbody > tr')
      end

      if row["rel"].to_i <= 2006
        rows = row.css('table[cellpadding=3] > tbody > tr')
      end

        
      rows.each_with_index do |new_row, index|
        if conditions(row, new_row)
          if new_row.css("td").to_a.size >= 4
            if new_row.css("td")[0].content.split("").size > 2
              post["name"] = new_row.css("td")[0].content
              post["date"] = new_row.css("td")[1].content
              post["title"] = new_row.css("td")[2].content
              post["link"] = new_row.css("td")[2]&.css("a")[0] ? new_row.css("td")[2]&.css("a")[0]["href"] : nil
              evaluations.push(new_row.css("td")[3].content)
            else
              post["evaluations"] = evaluations

              create_dissertation(post, row["rel"], true)

              posts.push(post)
              post = {}
              evaluations = []
            end
          else
            evaluations.push(new_row.css("td")[0].content)
          end

        elsif conditions_2019(row, new_row) || conditions_2005(row, new_row)
          post["name"] = new_row.css("td")[0].content
          post["date"] = new_row.css("td")[1].content
          post["title"] = new_row.css("td")[2].content
          post["link"] = new_row.css("td")[2]&.css("a")[0] ? new_row.css("td")[2]&.css("a")[0]["href"] : nil
          post["evaluations"] = new_row.css("td")[3].content.gsub("Orientador:", "")
            
          create_dissertation(post, row["rel"])

          posts.push(post)
          post = {}
          evaluations = []
        elsif conditions_2017(row, new_row)
          if new_row.css("td").size == 6
            post["name"] = new_row.css("td")[0].content
            post["date"] = new_row.css("td")[1].content
            post["title"] = new_row.css("td")[2].css("p")[0].content
            post["link"] = new_row.css("td")[4]&.css("a")[0]["href"]
            post["evaluations"] = new_row.css("td")[5].content
            create_dissertation(post, row["rel"])
            posts.push(post)
            post = {}
            evaluations = []
          end    
        elsif conditions_2016(row, new_row)
          if new_row.css("td").size == 5
            post["name"] = new_row.css("td").to_a[0].content
            post["date"] = "01/01/#{row["rel"]}"
            post["title"] = new_row.css("td")[1].css("p")[0] ? new_row.css("td")[1].css("p")[0].content : new_row.css("td")[1].content.gsub(":: Resumo", "").gsub(":: Completa", "")
            post["link"] = new_row.css("td").to_a[3].css("a")[0] ? new_row.css("td").to_a[3].css("a")[0]["href"] : nil 
            post["evaluations"] = new_row.css("td").to_a[4].content
            create_dissertation(post, row["rel"])
            posts.push(post)
            post = {}
            evaluations = []
          end
        end
      end

      data["posts"] = posts
      array_content.push(data)
    end

    return array_content
  end

  def create_dissertation(post, year, is_array = false)
    Dissertation.create(
      name: post.dig("name"),
      title: post.dig("title"),
      link: post.dig("link"),
      year: year,
      kind: :admin,
      evaluations: is_array ? post.dig("evaluations").join(", ") : post.dig("evaluations"),
    )
  end

  def exclude_heights
    ["height: 84px;", "height: 98px;", "height: 78px;", "height: 118px;"]
  end

  def conditions(row, new_row)
    ["2022", "2021", "2020", "2018"].include?(row["rel"]) && !new_row.css("td")[0].content.include?("Mestrando") && !exclude_heights.include?(new_row["style"])
  end

  def conditions_2019(row, new_row)
    return ["2019"].include?(row["rel"]) && ["height: 98px;", "height: 78px;"].include?(new_row["style"])
  end

  def conditions_2005(row, new_row)
    return ["2005", "2004"].include?(row["rel"])
  end

  def conditions_2017(row, new_row)
    return ["2017", "2015", "2014"].include?(row["rel"])
  end

  def conditions_2016(row, new_row)
    return ["2016", "2013", "2012", "2011", "2010", "2009", "2008", "2007", "2006"].include?(row["rel"])
  end
end
