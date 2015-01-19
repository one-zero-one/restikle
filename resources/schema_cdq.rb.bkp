#
# Notes:
#
# 20140611:01: Initial version
#

schema "20140611-0001" do

  entity "PasswordResetter" do
  end

  entity "Token" do
    string     :authentication_token,  default:  ''
    string     :email,                 optional: true
    string     :name,                  optional: true
    string     :salt,                  optional: true
    has_one    :shopper,               optional: true
    has_one    :merchant,              optional: true
  end

  entity "Address" do
    datetime   :created_at
    datetime   :updated_at
    datetime   :deleted_at
    string     :street,                default: ''
    string     :city,                  default: ''
    string     :state,                 default: ''
    string     :postcode,              default: ''
    string     :country,               default: ''
    string     :countrycode,           default: 'AU'
  end

  entity "Fund" do
    datetime   :created_at
    datetime   :updated_at
    datetime   :deleted_at
    integer64  :fund_id,               default: -1
    string     :nickname,              default: 'FUND'
    string     :source,                default: 'visa'
    string     :name_on_card,          default: '######## ########'
    string     :ppc_hash,              default: ''
    string     :address_line_one,      default: ''
    string     :address_line_two,      default: ''
    string     :address_city,          default: ''
    string     :address_postcode,      default: ''
    string     :address_state,         default: ''
    string     :address_country,       default: ''
    string     :number,                default: '####-####-####-####'
    string     :security_code,         default: '###'
    string     :expiry_month,          default: '##'
    string     :expiry_year,           default: '####'
    integer64  :shopper_ref,           default: -1
    belongs_to :shopper,               optional: true
  end

  entity "Item" do
    datetime   :created_at
    datetime   :updated_at
    datetime   :deleted_at
    integer64  :item_id,               default: -1
    integer64  :variant_ref,           default: -1
    integer64  :purchase_ref,          default: -1
    string     :name,                  default: ''
    string     :desc,                  default: ''
    integer32  :quantity,              default: 1
    integer32  :price,                 default: 0
    integer16  :tax_rate,              default: 10
    string     :image_url,             default: nil
    belongs_to :purchase,              optional: true
    belongs_to :variant,               optional: true
  end

  entity "StoreLocation" do
    datetime   :created_at
    datetime   :updated_at
    datetime   :deleted_at
    integer64  :store_location_id,     default: -1
    float      :lat,                   default: 0.0
    float      :lon,                   default: 0.0
    float      :term1,                 default: 0.0
    float      :term2,                 default: 0.0
    float      :term3,                 default: 0.0
    float      :term4,                 default: 0.0
    float      :term5,                 default: 0.0
    float      :term6,                 default: 0.0
    boolean    :calibrated,            default: false
    has_one    :store,                 optional: true
  end

  entity "Merchant" do
    datetime   :created_at
    datetime   :updated_at
    datetime   :deleted_at
    integer64  :merchant_id,           default: -1
    string     :name,                  default: ''
    string     :merchant_url,          default: ''
    integer32  :max_transaction_value, default: 100000
    has_many   :products,              optional: true
    has_many   :stores,                optional: true
    has_many   :users,                 optional: true
    has_one    :token,                 optional: true
  end

  entity "Payment" do
    datetime   :created_at,            default: Time.now
    datetime   :updated_at
    datetime   :deleted_at
    integer64  :payment_id,            default: -1
    integer32  :amount,                default: 0
    string     :currency,              default: 'AUD'
    string     :status,                default: nil
    string     :token,                 default: nil
    string     :ip_address,            default: nil
    integer64  :purchase_ref,          default: -1
    belongs_to :purchase,              optional: true
  end

  entity "Product" do
    datetime   :created_at
    datetime   :updated_at
    datetime   :deleted_at
    integer64  :product_id,            default: -1
    integer64  :merchant_ref,          default: -1
    string     :name,                  default: ''
    string     :desc,                  default: ''
    integer32  :rrp,                   default: 0
    string     :currency,              default: 'AUD'
    string     :upc,                   default: nil
    string     :url,                   default: ''
    string     :hash_tag,              default: ''
    string     :picture,               default: nil
    string     :product_image,         default: nil
    belongs_to :merchant,              optional: true
    has_many   :variants,              optional: true
  end

  entity "Purchase" do
    datetime   :created_at,            default: Time.now
    datetime   :updated_at
    datetime   :deleted_at
    integer64  :purchase_id,           default: -1
    integer64  :shopper_ref,           default: -1
    integer64  :store_ref,             default: -1
    string     :status,                default: 'pending'
    integer64  :validated_by,          default: nil
    integer32  :total,                 default: 0
    integer32  :tax,                   default: 0
    string     :currency,              default: 'AUD'
    string     :qr_ref,                default: ''
    string     :pickup_type,           default: 'at_purchase'
    belongs_to :shopper,               optional: true
    belongs_to :store,                 optional: true
    has_many   :payments,              optional: true
    has_many   :items,                 optional: true
  end

  entity "Shopper" do
    datetime   :created_at
    datetime   :updated_at
    datetime   :deleted_at
    integer64  :shopper_id,            default: -1
    string     :email,                 default: ''
    has_one    :user,                  optional: true
    has_many   :funds,                 optional: true
    has_many   :purchases,             optional: true
    has_one    :token,                 optional: true
    has_many   :shopper_visits,        optional: true
  end

  entity "ShopperVisit" do
    datetime   :created_at
    datetime   :updated_at
    datetime   :deleted_at
    datetime   :time_entered
    datetime   :time_exited
    integer64  :shopper_visit_id,      default: -1
    integer64  :shopper_ref,           default: -1
    integer64  :store_ref,             default: -1
    belongs_to :shopper,               optional: true
    belongs_to :store,                 optional: true
  end

  entity "Store" do
    datetime   :created_at
    datetime   :updated_at
    datetime   :deleted_at
    integer64  :store_id,              default: -1
    integer64  :merchant_ref,          default: -1
    string     :name,                  default: ''
    string     :currency,              default: 'AUD'
    integer16  :dft_tax_rate,          default: 10
    string     :street,                default: ''
    string     :city,                  default: ''
    string     :state,                 default: ''
    string     :postcode,              default: ''
    string     :country,               default: ''
    string     :countrycode,           default: ''
    string     :store_url,             default: ''
    string     :enabled,               default: true
    integer32  :max_transaction_value, default: 100000
    string     :avatar_url,            default: ''
    has_many   :variants,              optional: true
    belongs_to :merchant,              optional: true
    has_one    :store_location,        optional: true
    has_many   :purchases,             optional: true
    has_many   :shopper_visits,        optional: true
  end

  entity "User" do
    datetime   :created_at
    datetime   :updated_at
    datetime   :deleted_at
    integer64  :user_id,               default: -10
    string     :authentication_token,  default: ''
    string     :salt,                  default: ''
    string     :name,                  default: ''
    string     :email,                 default: ''
    string     :password,              default: ''
    string     :password_confirmation, default: ''
    boolean    :merchant_admin,        default: false
    string     :phone_number,          default: ''
    belongs_to :merchant,              optional: true
    has_one    :shopper,               optional: true
  end

  entity "Variant" do
    datetime   :created_at
    datetime   :updated_at
    datetime   :deleted_at
    integer64  :variant_id,            default: -1
    string     :currency,              default: 'AUD'
    integer32  :price,                 default: 0
    integer32  :quantity,              default: 1
    string     :upc,                   default: nil
    integer16  :tax_rate,              default: 10
    belongs_to :product,               optional: true
    belongs_to :store,                 optional: true
    has_many   :items,                 optional: true
  end

end
