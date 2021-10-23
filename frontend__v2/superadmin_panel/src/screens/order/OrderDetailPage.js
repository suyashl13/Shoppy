import React from 'react'
import { useParams } from 'react-router'
import { useContext } from 'react/cjs/react.development'
import { SubdealerProductTile } from '../../components/subdealer/slug/SubdealerProducts'
import { OrderContext } from '../../contexts/OrderContext'

export default function OrderDetailPage() {

    const { order_id } = useParams()
    const { orderList } = useContext(OrderContext)
    const kOrder = orderList?.filter(e => e.id == order_id)[0]

    return (
        <div className='container mt-5'>
            <div className="row">
                <div className="col-lg-5 col-sm-12 col-md-6">
                    <h3>Order #{kOrder?.id}</h3>
                    <hr />
                    <h5>Order Details</h5>
                    Delivery Address : {kOrder?.shipping_address} <br />
                    Subtotal : Rs.{kOrder?.subtotal} <br />
                    Delivered : {kOrder?.is_delivered ? "Yes" : "No"} <br />
                    Verified : {kOrder?.is_verified ? "Yes" : "No"} <br />
                    Order Status : {kOrder?.order_status}<br />
                    <hr />
                    <h5>Customer Details</h5>
                    {kOrder?.user ? <>
                        Name : {kOrder?.user.name} <br />
                        Address : {kOrder?.user.address} <br />
                        Email : {kOrder?.user.email} <br />
                        Phone : {kOrder?.user.phone} <br />
                        {/* Pincode : {kOrder?.user?.pincode} */}
                    </> : <center className='text-muted m-5' style={{ fontSize: '20px' }}>No Information</center>}
                    <hr />
                    <h5>Delivery Person Details <sup style={{fontSize: '12px', color: 'grey'}}> (Applicable if delivered by staff person.)</sup></h5>
                    {kOrder?.assigned_to ? <>
                        Name : {kOrder?.assigned_to.name} <br />
                        Address : {kOrder?.assigned_to.address} <br />
                        Email : {kOrder?.assigned_to.email} <br />
                        Phone : {kOrder?.assigned_to.phone} <br />
                        Pincode : {kOrder?.assigned_to.pincode}
                    </> : <center className='text-muted m-5' style={{ fontSize: '20px' }}>No Information</center>}
                    <hr />
                    <h5>Courier Delivery Details <sup style={{fontSize: '12px', color: 'grey'}}> (Applicable if delivered by courier)</sup></h5>
                    {kOrder?.courier_details ? <>
                       Courier Name : {kOrder?.courier_details?.courier_name} <br />
                       Courier Tracking Id : {kOrder?.courier_details?.courier_tracking_id}
                    </> : <center className='text-muted m-5' style={{ fontSize: '20px' }}>No Information</center>}
                    <hr />
                </div>
                <div className="col-lg-7 col-sm-12 col-md-6">
                    <h5>Cart Items</h5>
                    <hr />
                    <CartProducts cart_items={kOrder?.cart_items} />
                    <br />
                </div>
            </div>
        </div>
    )
}

const CartProducts = ({ cart_items }) => {
    return (
        !cart_items?.length ? "No Items in cart" :
            <div className='list-group'>
                {
                    cart_items?.map((item, index) => {
                        var extraOrderDetails = (
                            <div className='mt-2 text-info'>
                                Quantity : {item.quantity} <br />
                                Discount : {item.product.discount}% <br />
                                Tax : {item.product.tax_percentage}%
                            </div>
                        );
                        return <SubdealerProductTile product={item?.product}>
                            {extraOrderDetails}
                        </SubdealerProductTile>
                    })
                }
            </div>);
}