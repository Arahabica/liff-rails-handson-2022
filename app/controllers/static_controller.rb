# APIではないので直接、ActionController::Baseから継承
class StaticController < ActionController::Base
  def root
    # 静的ファイルの配信
    render file: 'public/index.html', layout: false, content_type: 'text/html'
  end
end
