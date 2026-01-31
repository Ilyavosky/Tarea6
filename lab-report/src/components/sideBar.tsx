import React from 'react';
import { List, ListItem, ListItemButton, ListItemText } from '@mui/material';

const Sidebar = () => {
  return (
    <div style={{ width: '240px', height: '100vh', backgroundColor: '#282c34' }}>
      <List>
        <ListItem disablePadding>
          <ListItemButton>
            <ListItemText primary="Dashboard" />
          </ListItemButton>
        </ListItem>
        <ListItem disablePadding>
          <ListItemButton>
            <ListItemText primary="Views" />
          </ListItemButton>
        </ListItem>
      </List>
    </div>
  );
};

export default Sidebar;