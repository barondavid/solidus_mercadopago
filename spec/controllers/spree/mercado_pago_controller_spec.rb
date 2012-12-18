# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Spree::MercadoPagoController do
  it "handles case where user is logged out redirects to login and back again"
  it "doesn't affect current order if there is one (session[:order_id])"
  
  describe "#success" do
    let(:user)           { create(:user) }
    let(:payment_method) { create(:payment_method, type: "PaymentMethod::MercadoPago") }
    let(:order)          do
      order = create(:order, user: user, state: "payment")
      create(:payment, payment_method: payment_method, order: order)
      order
    end

    before { controller.stub(:spree_current_user => user) }

    it "returns success" do
      order.payment.should_not be_nil
      order.payment_method.should_not be_nil
      order.payment_method.type.should eq("PaymentMethod::MercadoPago")
      spree_get :success, { order_number: order.number }
      response.should be_success
    end

    it "marks the order as complete" do
      spree_get :success, { order_number: order.number }
      assigns(:order).should_not be_nil
      assigns(:order).state.should eq("complete")
      assigns(:order).id.should eq(order.id)
    end
  end

  describe "#pending" do
    it "marks order as complete"
    it "shows pending payment message"
  end

  describe "#failure" do
    it "leaves order in payment state"
    it "shows failure (or cancelled) message"
  end
end
