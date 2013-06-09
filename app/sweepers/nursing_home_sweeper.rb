class NursingHomeSweeper < ActionController::Caching::Sweeper
  observe NursingHome

  def expire_cache_for(nursing_home)
    # Brute force: create, update and delete is very rare
    Rails.cache.clear
  end

  alias_method :after_create, :expire_cache_for
  alias_method :after_update, :expire_cache_for
  alias_method :after_destroy, :expire_cache_for
  alias_method :expire_cache_for, :expire_cache_for
end
