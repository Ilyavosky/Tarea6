import React from 'react';
import Sidebar from '../components/sideBar';
import Header from '../components/header';
import Dashboard from '../components/dashboard';

const Home = () => {
  return (
    <div style={{ display: 'flex' }}>
      <Sidebar />
      <div style={{ flexGrow: 1 }}>
        <Header />
        <Dashboard />
      </div>
    </div>
  );
};

export default Home;