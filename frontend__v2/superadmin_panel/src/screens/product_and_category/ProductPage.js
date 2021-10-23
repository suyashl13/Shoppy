import React, { useState } from 'react'
import { useContext } from 'react/cjs/react.development'
import CategoryList from '../../components/products_and_categories/CategoryList'
import ProductList from '../../components/products_and_categories/ProductList'
import { ProductContext } from '../../contexts/ProductContext'

export default function ProductPage() {

    const [activeTab, setActiveTab] = useState('products')

    const { productAndCategoryList } = useContext(ProductContext)

    return (
        <div className='container mt-5'>
            <h2>Products and Categories</h2>
            <hr />
            <ul className="nav nav-pills nav-fill">
                <li className="nav-item">
                    <button className={activeTab == 'products' ? 'nav-link active' : 'nav-link'} onClick={() => { setActiveTab('products') }} aria-current="page">Products</button>
                </li>
                <li className="nav-item">
                    <button className={activeTab == 'categories' ? 'nav-link active' : 'nav-link'} onClick={() => { setActiveTab('categories') }} aria-current="page">Categories</button>
                </li>
            </ul>
            <hr />
            {
                activeTab === 'products' ?
                <ProductList products={productAndCategoryList?.products} /> : 
                <CategoryList categories={productAndCategoryList?.categories} />
            }
        </div>
    )
}
