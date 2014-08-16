def save_and_open_preview
  `open #{file_preview_url(host: 'localhost:3000', file: save_page)}`
end
