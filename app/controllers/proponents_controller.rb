# frozen_string_literal: true

class ProponentsController < BaseController
  def show
    status, content, serializer = Http::ShowProponent::Service.(show_params)
    render json: content, status: status, serializer: serializer
  end

  def create
    status, content, serializer = Http::CreateProponent::Service.(create_params)
    render json: content, status: status, serializer: serializer
  end

  def update
    status, content, serializer = Http::UpdateProponent::Service.(update_params)
    render json: content, status: status, serializer: serializer
  end

  def list
    status, content, serializer = Http::ListProponents::Service.(list_params)
    render json: content, status: status, each_serializer: serializer
  end

  def destroy
    status, content, serializer = Http::DestroyProponent::Service.(destroy_params)
    render json: content, status: status, serializer: serializer
  end

  def discount_amount
    status, content, serializer = Http::DiscountAmount::Service.(discount_amount_params)
    render json: content, status: status, serializer: serializer
  end

  private

  def create_params
    params.permit(
      :name,
      :taxpayer_number,
      :birthdate,
      :amount,
      addresses_attributes: [
        :address,
        :number,
        :district,
        :city,
        :state,
        :zip
      ],
      contacts_attributes: [:number]
    )
  end

  def list_params
    params.permit(:page, :per_page)
  end

  def update_params
    params.permit(
      :id,
      :name,
      :taxpayer_number,
      :birthdate,
      :amount,
      addresses_attributes: [
        :id,
        :address,
        :number,
        :district,
        :city,
        :state,
        :zip,
        :_destroy
      ],
      contacts_attributes: [:id, :number, :_destroy]
    )
  end

  def destroy_params
    params.permit(:id)
  end

  def show_params
    params.permit(:id)
  end

  def discount_amount_params
    params.permit(:amount)
  end
end
