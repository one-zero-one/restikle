# This file was generated by Restikle, do not edit
schema "20150111075238" do
  entity "FriendlyIdSlug" do
    t.string     slug, null: false
    t.integer    sluggable_id, null: false
    t.string     sluggable_type, limit: 50
    t.string     scope
    t.datetime   created_at
  end
  entity "Address" do
    t.string     firstname
    t.string     lastname
    t.string     address1
    t.string     address2
    t.string     city
    t.string     zipcode
    t.string     phone
    t.string     state_name
    t.string     alternative_phone
    t.string     company
    t.integer    state_id
    t.integer    country_id
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "Adjustment" do
    t.integer    source_id
    t.string     source_type
    t.integer    adjustable_id
    t.string     adjustable_type
    t.decimal    amount, precision: 10, scale: 2
    t.string     label
    t.boolean    mandatory
    t.boolean    eligible, default: true
    t.datetime   created_at
    t.datetime   updated_at
    t.string     state
    t.integer    order_id
    t.boolean    included, default: false
  end
  entity "Asset" do
    t.integer    viewable_id
    t.string     viewable_type
    t.integer    attachment_width
    t.integer    attachment_height
    t.integer    attachment_file_size
    t.integer    position
    t.string     attachment_content_type
    t.string     attachment_file_name
    t.string     type, limit: 75
    t.datetime   attachment_updated_at
    t.text       alt
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "Calculator" do
    t.string     type
    t.integer    calculable_id
    t.string     calculable_type
    t.datetime   created_at
    t.datetime   updated_at
    t.text       preferences
  end
  entity "Configuration" do
    t.string     name
    t.string     type, limit: 50
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "Country" do
    t.string     iso_name
    t.string     iso
    t.string     iso3
    t.string     name
    t.integer    numcode
    t.boolean    states_required, default: false
    t.datetime   updated_at
  end
  entity "CreditCard" do
    t.string     month
    t.string     year
    t.string     cc_type
    t.string     last_digits
    t.integer    address_id
    t.string     gateway_customer_profile_id
    t.string     gateway_payment_profile_id
    t.datetime   created_at
    t.datetime   updated_at
    t.string     name
    t.integer    user_id
    t.integer    payment_method_id
    t.boolean    default, default: false, null: false
  end
  entity "CustomerReturn" do
    t.string     number
    t.integer    stock_location_id
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "Gateway" do
    t.string     type
    t.string     name
    t.text       description
    t.boolean    active, default: true
    t.string     environment, default: "development"
    t.string     server, default: "test"
    t.boolean    test_mode, default: true
    t.datetime   created_at
    t.datetime   updated_at
    t.text       preferences
  end
  entity "InventoryUnit" do
    t.string     state
    t.integer    variant_id
    t.integer    order_id
    t.integer    shipment_id
    t.datetime   created_at
    t.datetime   updated_at
    t.boolean    pending, default: true
    t.integer    line_item_id
  end
  entity "LineItem" do
    t.integer    variant_id
    t.integer    order_id
    t.integer    quantity, null: false
    t.decimal    price, precision: 10, scale: 2, null: false
    t.datetime   created_at
    t.datetime   updated_at
    t.string     currency
    t.decimal    cost_price, precision: 10, scale: 2
    t.integer    tax_category_id
    t.decimal    adjustment_total, precision: 10, scale: 2, default: 0.0
    t.decimal    additional_tax_total, precision: 10, scale: 2, default: 0.0
    t.decimal    promo_total, precision: 10, scale: 2, default: 0.0
    t.decimal    included_tax_total, precision: 10, scale: 2, default: 0.0, null: false
    t.decimal    pre_tax_amount, precision: 8, scale: 2, default: 0.0
  end
  entity "LogEntry" do
    t.integer    source_id
    t.string     source_type
    t.text       details
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "OptionType" do
    t.string     name, limit: 100
    t.string     presentation, limit: 100
    t.integer    position, default: 0, null: false
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "OptionTypesPrototype" do
    t.integer    prototype_id
    t.integer    option_type_id
  end
  entity "OptionValue" do
    t.integer    position
    t.string     name
    t.string     presentation
    t.integer    option_type_id
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "OptionValuesVariant" do
    t.integer    variant_id
    t.integer    option_value_id
  end
  entity "Order" do
    t.string     number, limit: 32
    t.decimal    item_total, precision: 10, scale: 2, default: 0.0, null: false
    t.decimal    total, precision: 10, scale: 2, default: 0.0, null: false
    t.string     state
    t.decimal    adjustment_total, precision: 10, scale: 2, default: 0.0, null: false
    t.integer    user_id
    t.datetime   completed_at
    t.integer    bill_address_id
    t.integer    ship_address_id
    t.decimal    payment_total, precision: 10, scale: 2, default: 0.0
    t.integer    shipping_method_id
    t.string     shipment_state
    t.string     payment_state
    t.string     email
    t.text       special_instructions
    t.datetime   created_at
    t.datetime   updated_at
    t.string     currency
    t.string     last_ip_address
    t.integer    created_by_id
    t.decimal    shipment_total, precision: 10, scale: 2, default: 0.0, null: false
    t.decimal    additional_tax_total, precision: 10, scale: 2, default: 0.0
    t.decimal    promo_total, precision: 10, scale: 2, default: 0.0
    t.string     channel, default: "spree"
    t.decimal    included_tax_total, precision: 10, scale: 2, default: 0.0, null: false
    t.integer    item_count, default: 0
    t.integer    approver_id
    t.datetime   approved_at
    t.boolean    confirmation_delivered, default: false
    t.boolean    considered_risky, default: false
    t.string     guest_token
    t.datetime   canceled_at
    t.integer    canceler_id
    t.integer    store_id
    t.integer    state_lock_version, default: 0, null: false
  end
  entity "OrdersPromotion" do
    t.integer    order_id
    t.integer    promotion_id
  end
  entity "PaymentCaptureEvent" do
    t.decimal    amount, precision: 10, scale: 2, default: 0.0
    t.integer    payment_id
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "PaymentMethod" do
    t.string     type
    t.string     name
    t.text       description
    t.boolean    active, default: true
    t.string     environment, default: "development"
    t.datetime   deleted_at
    t.datetime   created_at
    t.datetime   updated_at
    t.string     display_on
    t.boolean    auto_capture
    t.text       preferences
  end
  entity "Payment" do
    t.decimal    amount, precision: 10, scale: 2, default: 0.0, null: false
    t.integer    order_id
    t.integer    source_id
    t.string     source_type
    t.integer    payment_method_id
    t.string     state
    t.string     response_code
    t.string     avs_response
    t.datetime   created_at
    t.datetime   updated_at
    t.string     identifier
    t.string     cvv_response_code
    t.string     cvv_response_message
  end
  entity "Preference" do
    t.text       value
    t.string     key
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "Price" do
    t.integer    variant_id, null: false
    t.decimal    amount, precision: 10, scale: 2
    t.string     currency
    t.datetime   deleted_at
  end
  entity "ProductOptionType" do
    t.integer    position
    t.integer    product_id
    t.integer    option_type_id
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "ProductProperty" do
    t.string     value
    t.integer    product_id
    t.integer    property_id
    t.datetime   created_at
    t.datetime   updated_at
    t.integer    position, default: 0
  end
  entity "Product" do
    t.string     name, default: "", null: false
    t.text       description
    t.datetime   available_on
    t.datetime   deleted_at
    t.string     slug
    t.text       meta_description
    t.string     meta_keywords
    t.integer    tax_category_id
    t.integer    shipping_category_id
    t.datetime   created_at
    t.datetime   updated_at
    t.boolean    promotionable, default: true
    t.string     meta_title
  end
  entity "ProductsPromotionRule" do
    t.integer    product_id
    t.integer    promotion_rule_id
  end
  entity "ProductsTaxon" do
    t.integer    product_id
    t.integer    taxon_id
    t.integer    position
  end
  entity "PromotionActionLineItem" do
    t.integer    promotion_action_id
    t.integer    variant_id
    t.integer    quantity, default: 1
  end
  entity "PromotionAction" do
    t.integer    promotion_id
    t.integer    position
    t.string     type
    t.datetime   deleted_at
  end
  entity "PromotionCategory" do
    t.string     name
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "PromotionRule" do
    t.integer    promotion_id
    t.integer    user_id
    t.integer    product_group_id
    t.string     type
    t.datetime   created_at
    t.datetime   updated_at
    t.string     code
    t.text       preferences
  end
  entity "PromotionRulesUser" do
    t.integer    user_id
    t.integer    promotion_rule_id
  end
  entity "Promotion" do
    t.string     description
    t.datetime   expires_at
    t.datetime   starts_at
    t.string     name
    t.string     type
    t.integer    usage_limit
    t.string     match_policy, default: "all"
    t.string     code
    t.boolean    advertise, default: false
    t.string     path
    t.datetime   created_at
    t.datetime   updated_at
    t.integer    promotion_category_id
  end
  entity "Property" do
    t.string     name
    t.string     presentation, null: false
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "PropertiesPrototype" do
    t.integer    prototype_id
    t.integer    property_id
  end
  entity "Prototype" do
    t.string     name
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "RefundReason" do
    t.string     name
    t.boolean    active, default: true
    t.boolean    mutable, default: true
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "Refund" do
    t.integer    payment_id
    t.decimal    amount, precision: 10, scale: 2, default: 0.0, null: false
    t.string     transaction_id
    t.datetime   created_at
    t.datetime   updated_at
    t.integer    refund_reason_id
    t.integer    reimbursement_id
  end
  entity "ReimbursementCredit" do
    t.decimal    amount, precision: 10, scale: 2, default: 0.0, null: false
    t.integer    reimbursement_id
    t.integer    creditable_id
    t.string     creditable_type
  end
  entity "ReimbursementType" do
    t.string     name
    t.boolean    active, default: true
    t.boolean    mutable, default: true
    t.datetime   created_at
    t.datetime   updated_at
    t.string     type
  end
  entity "Reimbursement" do
    t.string     number
    t.string     reimbursement_status
    t.integer    customer_return_id
    t.integer    order_id
    t.decimal    total, precision: 10, scale: 2
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "ReturnAuthorizationReason" do
    t.string     name
    t.boolean    active, default: true
    t.boolean    mutable, default: true
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "ReturnAuthorization" do
    t.string     number
    t.string     state
    t.integer    order_id
    t.text       memo
    t.datetime   created_at
    t.datetime   updated_at
    t.integer    stock_location_id
    t.integer    return_authorization_reason_id
  end
  entity "ReturnItem" do
    t.integer    return_authorization_id
    t.integer    inventory_unit_id
    t.integer    exchange_variant_id
    t.datetime   created_at
    t.datetime   updated_at
    t.decimal    pre_tax_amount, precision: 12, scale: 4, default: 0.0, null: false
    t.decimal    included_tax_total, precision: 12, scale: 4, default: 0.0, null: false
    t.decimal    additional_tax_total, precision: 12, scale: 4, default: 0.0, null: false
    t.string     reception_status
    t.string     acceptance_status
    t.integer    customer_return_id
    t.integer    reimbursement_id
    t.integer    exchange_inventory_unit_id
    t.text       acceptance_status_errors
    t.integer    preferred_reimbursement_type_id
    t.integer    override_reimbursement_type_id
  end
  entity "Role" do
    t.string     name
  end
  entity "RolesUser" do
    t.integer    role_id
    t.integer    user_id
  end
  entity "Shipment" do
    t.string     tracking
    t.string     number
    t.decimal    cost, precision: 10, scale: 2, default: 0.0
    t.datetime   shipped_at
    t.integer    order_id
    t.integer    address_id
    t.string     state
    t.datetime   created_at
    t.datetime   updated_at
    t.integer    stock_location_id
    t.decimal    adjustment_total, precision: 10, scale: 2, default: 0.0
    t.decimal    additional_tax_total, precision: 10, scale: 2, default: 0.0
    t.decimal    promo_total, precision: 10, scale: 2, default: 0.0
    t.decimal    included_tax_total, precision: 10, scale: 2, default: 0.0, null: false
    t.decimal    pre_tax_amount, precision: 8, scale: 2, default: 0.0
  end
  entity "ShippingCategory" do
    t.string     name
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "ShippingMethodCategory" do
    t.integer    shipping_method_id, null: false
    t.integer    shipping_category_id, null: false
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "ShippingMethod" do
    t.string     name
    t.string     display_on
    t.datetime   deleted_at
    t.datetime   created_at
    t.datetime   updated_at
    t.string     tracking_url
    t.string     admin_name
    t.integer    tax_category_id
    t.string     code
  end
  entity "ShippingMethodsZone" do
    t.integer    shipping_method_id
    t.integer    zone_id
  end
  entity "ShippingRate" do
    t.integer    shipment_id
    t.integer    shipping_method_id
    t.boolean    selected, default: false
    t.decimal    cost, precision: 8, scale: 2, default: 0.0
    t.datetime   created_at
    t.datetime   updated_at
    t.integer    tax_rate_id
  end
  entity "SkrillTransaction" do
    t.string     email
    t.float      amount
    t.string     currency
    t.integer    transaction_id
    t.integer    customer_id
    t.string     payment_type
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "StateChange" do
    t.string     name
    t.string     previous_state
    t.integer    stateful_id
    t.integer    user_id
    t.string     stateful_type
    t.string     next_state
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "State" do
    t.string     name
    t.string     abbr
    t.integer    country_id
    t.datetime   updated_at
  end
  entity "StockItem" do
    t.integer    stock_location_id
    t.integer    variant_id
    t.integer    count_on_hand, default: 0, null: false
    t.datetime   created_at
    t.datetime   updated_at
    t.boolean    backorderable, default: false
    t.datetime   deleted_at
  end
  entity "StockLocation" do
    t.string     name
    t.datetime   created_at
    t.datetime   updated_at
    t.boolean    default, default: false, null: false
    t.string     address1
    t.string     address2
    t.string     city
    t.integer    state_id
    t.string     state_name
    t.integer    country_id
    t.string     zipcode
    t.string     phone
    t.boolean    active, default: true
    t.boolean    backorderable_default, default: false
    t.boolean    propagate_all_variants, default: true
    t.string     admin_name
  end
  entity "StockMovement" do
    t.integer    stock_item_id
    t.integer    quantity, default: 0
    t.string     action
    t.datetime   created_at
    t.datetime   updated_at
    t.integer    originator_id
    t.string     originator_type
  end
  entity "StockTransfer" do
    t.string     type
    t.string     reference
    t.integer    source_location_id
    t.integer    destination_location_id
    t.datetime   created_at
    t.datetime   updated_at
    t.string     number
  end
  entity "Store" do
    t.string     name
    t.string     url
    t.text       meta_description
    t.text       meta_keywords
    t.string     seo_title
    t.string     mail_from_address
    t.string     default_currency
    t.string     code
    t.boolean    default, default: false, null: false
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "TaxCategory" do
    t.string     name
    t.string     description
    t.boolean    is_default, default: false
    t.datetime   deleted_at
    t.datetime   created_at
    t.datetime   updated_at
    t.string     tax_code
  end
  entity "TaxRate" do
    t.decimal    amount, precision: 8, scale: 5
    t.integer    zone_id
    t.integer    tax_category_id
    t.boolean    included_in_price, default: false
    t.datetime   created_at
    t.datetime   updated_at
    t.string     name
    t.boolean    show_rate_in_label, default: true
    t.datetime   deleted_at
  end
  entity "Taxonomy" do
    t.string     name, null: false
    t.datetime   created_at
    t.datetime   updated_at
    t.integer    position, default: 0
  end
  entity "Taxon" do
    t.integer    parent_id
    t.integer    position, default: 0
    t.string     name, null: false
    t.string     permalink
    t.integer    taxonomy_id
    t.integer    lft
    t.integer    rgt
    t.string     icon_file_name
    t.string     icon_content_type
    t.integer    icon_file_size
    t.datetime   icon_updated_at
    t.text       description
    t.datetime   created_at
    t.datetime   updated_at
    t.string     meta_title
    t.string     meta_description
    t.string     meta_keywords
    t.integer    depth
  end
  entity "TaxonsPromotionRule" do
    t.integer    taxon_id
    t.integer    promotion_rule_id
  end
  entity "TaxonsPrototype" do
    t.integer    taxon_id
    t.integer    prototype_id
  end
  entity "TokenizedPermission" do
    t.integer    permissable_id
    t.string     permissable_type
    t.string     token
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "Tracker" do
    t.string     environment
    t.string     analytics_id
    t.boolean    active, default: true
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "User" do
    t.string     encrypted_password, limit: 128
    t.string     password_salt, limit: 128
    t.string     email
    t.string     remember_token
    t.string     persistence_token
    t.string     reset_password_token
    t.string     perishable_token
    t.integer    sign_in_count, default: 0, null: false
    t.integer    failed_attempts, default: 0, null: false
    t.datetime   last_request_at
    t.datetime   current_sign_in_at
    t.datetime   last_sign_in_at
    t.string     current_sign_in_ip
    t.string     last_sign_in_ip
    t.string     login
    t.integer    ship_address_id
    t.integer    bill_address_id
    t.string     authentication_token
    t.string     unlock_token
    t.datetime   locked_at
    t.datetime   reset_password_sent_at
    t.datetime   created_at
    t.datetime   updated_at
    t.string     spree_api_key, limit: 48
    t.datetime   remember_created_at
    t.datetime   deleted_at
    t.string     confirmation_token
    t.datetime   confirmed_at
    t.datetime   confirmation_sent_at
  end
  entity "Variant" do
    t.string     sku, default: "", null: false
    t.decimal    weight, precision: 8, scale: 2, default: 0.0
    t.decimal    height, precision: 8, scale: 2
    t.decimal    width, precision: 8, scale: 2
    t.decimal    depth, precision: 8, scale: 2
    t.datetime   deleted_at
    t.boolean    is_master, default: false
    t.integer    product_id
    t.decimal    cost_price, precision: 10, scale: 2
    t.integer    position
    t.string     cost_currency
    t.boolean    track_inventory, default: true
    t.integer    tax_category_id
    t.datetime   updated_at
    t.integer    stock_items_count, default: 0, null: false
  end
  entity "ZoneMember" do
    t.integer    zoneable_id
    t.string     zoneable_type
    t.integer    zone_id
    t.datetime   created_at
    t.datetime   updated_at
  end
  entity "Zone" do
    t.string     name
    t.string     description
    t.boolean    default_tax, default: false
    t.integer    zone_members_count, default: 0
    t.datetime   created_at
    t.datetime   updated_at
  end
end
