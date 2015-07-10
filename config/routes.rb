Clio::Application.routes.draw do

  # This is getting masked.... try it up here?
  get "catalog/endnote", :as => "endnote_catalog"

  # and this..
  get 'catalog/:id/librarian_view', :to => "catalog#librarian_view", :as => "librarian_view_catalog"
  # Again, blacklight inserts this as GET, we need to support PUT
  # (due to Blacklight's mechanism of preserving search context.)
  # match 'catalog/:id/librarian_view', via: [:put], to: 'catalog#librarian_view_update'
  match 'catalog/:id/librarian_view_track', via: [:post], to: 'catalog#librarian_view_track'

  # resources :saved_list_items
  resources :saved_lists

  match 'lists/add(/:item_key_list)', via: [:get, :post], to: 'saved_lists#add', as: :savedlist_add
  # Cannot restrict to POST, WIND auth always redirects via GET
  # get 'lists/add', via: [:post], to: 'saved_lists#add', as: :savedlist_add
  # get 'lists/add', to: 'saved_lists#add'

  get 'lists/remove', via: [:get], to: 'saved_lists#remove', as: :savedlist_remove
  get 'lists/move', via: [:get], to: 'saved_lists#move', as: :savedlist_move
  get 'lists/copy', via: [:get], to: 'saved_lists#copy', as: :savedlist_copy
  get '/lists/email(.:format)', to: 'saved_lists#email', as: :email_savedlist

  # These have to come LAST of the lists paths
  # They get any 2nd token as :owner, you'll never fallback to later routes
  get 'lists(/:owner(/:slug))', to: 'saved_lists#show', as: :lists
  get 'lists(/:owner(/:slug))/edit', to: 'saved_lists#edit', as: :edit_lists

  #  Use this section for ad-hoc routing overrides during localhost development
  if Rails.env.development?
    # such as... turn off unapi support, to simplify debugging?
    # get '/catalog/unapi' => proc { [404, {}, ['']] }
  end

  resources :item_alerts

  get 'item_alerts/:id/show_table_row(.:format)', to: 'item_alerts#show_table_row', as: :item_alert_show_table_row
  get 'spectrum/search'

  Blacklight.add_routes(self)

  root to: 'spectrum#search', defaults: { layout: 'quicksearch' }

  devise_for :users, controllers: { sessions: 'sessions' }

  get 'catalog', to: 'catalog#index', as: :base_catalog_index

  get 'quicksearch/', to: 'spectrum#search', as: :quicksearch_index, defaults: { layout: 'quicksearch' }

  # "Browser Options" are things like facet open/close state, view-style, etc.
  get 'set_browser_option', to: 'application#set_browser_option_handler'
  get 'get_browser_option', to: 'application#get_browser_option_handler'

  # Support for persisent selected-item lists
  get 'selected_items', to: 'application#selected_items_handler'

  # Is this redundant with above "evise_for :users, controllers:..." ?
  # devise_for :users

  match 'databases', to: 'catalog#index', as: :databases_index
  match 'databases/:id(.:format)', via: [:get], to: 'catalog#show', as: :databases_show
  match 'databases/facet/:id(.format)', to: 'catalog#facet', as: :databases_facet
  # match 'databases/:id(.:format)', via: [:put], to: 'catalog#update', as: :databases_update
  match 'databases/:id/track(.:format)', via: [:post], to: 'catalog#track', as: :databases_track
  get 'databases/:id/librarian_view', :to => "catalog#librarian_view", :as => "librarian_view_databases"
  match 'databases/:id/librarian_view_track', via: [:post], to: 'databases#librarian_view_track'

  match 'journals', to: 'catalog#index', as: :journals_index
  match 'journals/:id(.:format)', via: [:get], to: 'catalog#show', as: :journals_show
  match 'journals/facet/:id(.format)', to: 'catalog#facet', as: :journals_facet
  # match 'journals/:id(.:format)', via: [:put], to: 'catalog#update', as: :journals_update
  match 'journals/:id/track(.:format)', via: [:post], to: 'catalog#track', as: :journals_track
  get 'journals/:id/librarian_view', :to => "catalog#librarian_view", :as => "librarian_view_journals"
  match 'journals/:id/librarian_view_track', via: [:post], to: 'journals#librarian_view_track'

  get 'library_web', to: 'spectrum#search', as: :library_web_index, defaults: { layout: 'library_web' }

  get 'academic_commons', to: 'catalog#index', as: :academic_commons_index
  get 'academic_commons/range_limit(.:format)', to: 'catalog#range_limit', as: :academic_range_limit
  get 'academic_commons/facet/:id(.format)', to: 'catalog#facet', as: :academic_commons_facet

  get 'dcv', to: 'catalog#index', as: :dcv_index
  get 'dcv/facet/:id(.format)', to: 'catalog#facet', as: :dcv_facet

  match 'archives', to: 'catalog#index', as: :archives_index
  match 'archives/:id(.:format)', via: [:get], to: 'catalog#show', as: :archives_show
  match 'archives/facet/:id(.format)', to: 'catalog#facet', as: :archives_facet
  match 'archives/:id/track(.:format)', to: 'catalog#track', as: :archives_track
  get 'archives/:id/librarian_view', :to => "catalog#librarian_view", :as => "librarian_view_archives"
  match 'archives/:id/librarian_view_track', via: [:post], to: 'archives#librarian_view_track'

  # NEXT-483 A user should be able to browse results using previous/next
  # this requires GET ==> show, and POST ==> update, for reasons
  # explained in the ticket.
  match 'new_arrivals', to: 'catalog#index', as: :new_arrivals_index
  match 'new_arrivals/:id(.:format)', via: [:get], to: 'catalog#show', as: :new_arrivals_show
  match 'new_arrivals/facet/:id(.format)', to: 'catalog#facet', as: :new_arrivals_facet
  # match 'new_arrivals/:id(.:format)', via: [:put], to: 'catalog#update', as: :new_arrivals_update
  match 'new_arrivals/:id/track(.:format)', via: [:post], to: 'catalog#track', as: :new_arrivals_track
  get 'new_arrivals/:id/librarian_view', :to => "catalog#librarian_view", :as => "librarian_view_new_arrivals"
  match 'new_arrivals/:id/librarian_view_track', via: [:post], to: 'new_arrivals#librarian_view_track'

  match 'backend/holdings/:id' => 'backend#holdings', :as => 'backend_holdings'

  get 'backend/holdings/:id' => 'backend#holdings', :as => 'backend_holdings'

  get 'catalog/hathi_holdings/:id' => 'catalog#hathi_holdings', :as => 'hathi_holdings'

  get 'spectrum/fetch/:layout/:datasource', to: 'spectrum#fetch', as: 'spectrum_fetch'

  match 'articles', to: 'spectrum#search', as: :articles_index, via: [:get, :post], defaults: { layout: 'articles' }
  # there's no 'articles' controller, and no item-detail page for articles
  # get 'articles/show', :to => "articles#show", :as => :articles_show

  get 'ebooks', to: 'spectrum#search', as: :ebooks_index, defaults: { layout: 'ebooks' }
  get 'dissertations', to: 'spectrum#search', as: :dissertations_index, defaults: { layout: 'dissertations' }
  # redirect newspapers to articles
  # get 'newspapers', to: 'spectrum#search', as: :newspapers_index, defaults: { layout: 'newspapers' }
  get '/newspapers', to: redirect('/articles')

  get 'locations/show/:id', id: /[^\/]+/, to: 'locations#show', as: :location_display

  # this catches certain broken sessions, when somehow controller == spectrum and action == show
  get 'spectrum/show', to: 'spectrum#search', defaults: { layout: 'quicksearch' }

  # we get this from blacklight - but we need it to accept POST as well...
  # email_catalog GET    /catalog/email(.:format)                       catalog#email
  # sms_catalog GET    /catalog/sms(.:format)                         catalog#sms
  # 3/15, try without?
  # match '/catalog/email(.:format)' => 'catalog#email', as: :email_catalog, via: [:post]
  # match '/catalog/sms(.:format)' => 'catalog#sms', as: :sms_catalog, via: [:post]

  get '/catalog/email(.:format)', to: 'catalog#email', as: :email


  # no, this was never implemented
  # namespace :admin do
  #   resources :locations
  # end

  # No longer a given, must be part of Application's routes.rb, but only
  # inserted by the Blacklight MARC generator code.

  # Catalog stuff.

  # Call-Number Browse, based on Stanford Searchworks
  resources :browse, only: :index
  # Use distinct URLs for xhr v.s. html, to avoid cached-page problems, to customize html
  get 'browse/shelfkey_mini/:shelfkey(/:bib)', to: 'browse#shelfkey_mini', as: :browse_shelfkey_mini, :constraints => { :shelfkey => /[^\/]*/, :bib => /[^\/]*/ }
  get 'browse/shelfkey_full/:shelfkey(/:bib)', to: 'browse#shelfkey_full', as: :browse_shelfkey_full, :constraints => { :shelfkey => /[^\/]*/, :bib => /[^\/]*/ }

  # Rails 4 - move this to bottom, so it doesn't override other
  # routes that also go to 'catalog#index'
  # (Didn't have to do this with Rails 3 - what changed???)
  get 'catalog/advanced', to: 'catalog#index', as: :catalog_advanced, defaults: { q: '', show_advanced: 'true' }

end


