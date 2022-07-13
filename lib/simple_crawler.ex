defmodule SimpleCrawler do
  def get_url(url) do
    html = HTTPoison.get!(url)

    {:ok, document} = Floki.parse_document(html.body)
    document |> Floki.find("a") |> Floki.attribute("href")
  end
  def get_url_list(url_list) do
    domain = "https://thewaggletraining.github.io/"

    list =
      for url <- url_list do
        get_url(url)
        |> Enum.filter(& String.starts_with?(&1,domain))
      end
      List.flatten(list)
    end

 def get_page_text(url_list) do
  for url <- url_list do
     html = HTTPoison.get!(url)

     Floki.parse_document!(html.body)
     |>Floki.find("body")
     |>Floki.text()
     |>String.replace([" ","\n"],"")
   end
  end

  def main(url) do
    url_list = check_url([url])
    get_page_text(url_list)
  end

  def check_url(url_list) do
    all_url =Enum.uniq(url_list ++ get_url_list(url_list))

    if all_url == url_list do
      all_url
    else
      check_url(all_url)
    end
  end

end
