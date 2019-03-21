class ApplicationController < ActionController::API

  def require_params!(*keys)
    if(missing = keys.find{|k| !params.include?(k)})
      raise ActionController::BadRequest.new("missing required params #{missing}")
    end
  end

end
