import React, { useContext, useState } from 'react'
import { Redirect, useParams } from 'react-router'
import { toast } from 'react-toastify';
import { productContext } from '../../contexts/ProductContext';
import { updateProductAtBackend } from '../../helpers/BackendProductHelper';
import { tConvert } from '../../helpers/DateTimeHelper';

export default function ProductSlugPage() {

    const { id } = useParams()
    const { product, setProduct } = useContext(productContext)
    const myProduct = product?.products?.filter(e => e.id == id)[0];

    const [editedProductQuantity, setEditedProductQuantity] = useState(myProduct?.available_stock)
    const [isLoading, setIsLoading] = useState(false)

    if (!myProduct) {
        return <Redirect to='/pagenotfound' />
    }

    const updateProduct = async (productId, updateObject) => {
        setIsLoading(true)
        await updateProductAtBackend({
            onSuccess: (data) => {
                const updatedData = product?.products.map(val => {
                    if (val.id == id) {
                        return data;
                    } else {
                        return val;
                    }
                })
                setProduct({ ...product, products: updatedData })
                setIsLoading(false)
            },
            onError: (err) => {
                console.log(err)
                setIsLoading(false)
                toast("Something went wrong..", { type: 'error' })
            }
        }, productId, updateObject)
    }

    return (
        <div className='container p-4'>
            {myProduct?.is_active ? null : <div className='alert alert-danger' role='alert'>
                The product is currently not visible to customers as it has not been verified by superadmins yet. As verification is done it will be visible to customers.
            </div>}
            <div className="row">
                <div className="col-sm-12 ">
                    <center><img src={myProduct?.product_image} alt="product_image" className="mt-4 rounded-circle mb-5" height='240' width='238' /></center>
                    <center><h3>{myProduct?.title}</h3></center>
                    <br />
                </div>
                <div className="col-sm-12 pt-1">
                    {isLoading ?
                        <center>
                            <div className="spinner-border text-primary" role="status"></div>
                        </center>
                        : <table className="table table-bordered">
                            <tbody>
                                <tr>
                                    <th scope="row">Description</th>
                                    <td>{myProduct?.description}</td>
                                </tr>
                                <tr>
                                    <th scope="row">Available Stock</th>
                                    <td style={{
                                        display: 'flex',
                                        flexDirection: 'row'
                                    }} ><input type="number" className="form-control" style={{
                                        marginRight: '8px'
                                    }} value={editedProductQuantity} onChange={e => { setEditedProductQuantity(e.target.value) }} /> <button
                                        disabled={isLoading}
                                        onClick={async () => {
                                            updateProduct(myProduct.id, { 'available_stock': editedProductQuantity })
                                        }}
                                        className='btn btn-sm btn-primary mr-1'>Update</button> </td>
                                </tr>
                                <tr>
                                    <th scope="row">Is Available</th>
                                    <td style={{
                                        display: 'flex',
                                        flexDirection: 'row',
                                        justifyContent: 'space-between',
                                    }}><span>{myProduct?.is_available ? "Yes" : "No"}</span><button
                                        disabled={isLoading}
                                        onClick={e => { updateProduct(myProduct.id, { 'is_available': `${!myProduct?.is_available ? 'true' : 'false'}` }) }}
                                        className='btn btn-sm btn-primary mr-1'>{myProduct?.is_available ? "Deactivate" : "Activate"}</button> </td>
                                </tr>
                                <tr>
                                    <th scope="row">Is Active</th>
                                    <td >{myProduct?.is_active ? "Yes" : "No"}</td>
                                </tr>
                                <tr>
                                    <th scope="row">Base Value</th>
                                    <td>Rs. {myProduct?.base_price}</td>
                                </tr>
                                <tr>
                                    <th scope="row">Tax</th>
                                    <td >{myProduct?.tax_percentage}%</td>
                                </tr>
                                <tr>
                                    <th scope="row">Discount</th>
                                    <td >{myProduct?.discount}%</td>
                                </tr>
                                <tr>
                                    <th scope="row">Date Created</th>
                                    <td>{tConvert(myProduct?.date_time_created.split('T')[0])}</td>
                                </tr>
                            </tbody>
                        </table>}
                </div>
            </div>
        </div>
    );
}
