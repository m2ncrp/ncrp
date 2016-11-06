
String GetKeyNameByCode( DWORD dwCode )
{
    String strCode;

    if( dwCode >= 0x30 && dwCode <= 0x39 )
    {
        strCode = (unsigned char)dwCode;
    }
    else if( dwCode >= 0x41 && dwCode <= 0x5A )
    {
        strCode = (unsigned char)( dwCode + 0x20 );
    }
    else if( dwCode >= VK_NUMPAD0 && dwCode <= VK_NUMPAD9 )
    {
        strCode.Format( "num_%d", dwCode - VK_NUMPAD0 );
    }
    else if( dwCode >= VK_F1 && dwCode <= VK_F12 )
    {
        strCode.Format( "f%d", dwCode - VK_F1 + 1 );
    }
    else
    {
        switch( dwCode )
        {
        case VK_TAB:
            strCode = "tab"; break;
        case VK_RETURN:
            strCode = "enter"; break;
        case VK_CONTROL:
            strCode = "ctrl"; break;
        case VK_SHIFT:
            strCode = "shift"; break;
        case VK_MENU:
            strCode = "alt"; break;
        case VK_ADD:
            strCode = "num_add"; break;
        case VK_SUBTRACT:
            strCode = "num_sub"; break;
        case VK_DIVIDE:
            strCode = "num_div"; break;
        case VK_MULTIPLY:
            strCode = "num_mul"; break;
        case VK_SPACE:
            strCode = "space"; break;
        case VK_LEFT:
            strCode = "arrow_left"; break;
        case VK_RIGHT:
            strCode = "arrow_right"; break;
        case VK_UP:
            strCode = "arrow_up"; break;
        case VK_DOWN:
            strCode = "arrow_down"; break;
        case VK_PRIOR:
            strCode = "page_up"; break;
        case VK_NEXT:
            strCode = "page_down"; break;
        case VK_END:
            strCode = "end"; break;
        case VK_HOME:
            strCode = "home"; break;
        case VK_INSERT:
            strCode = "insert"; break;
        case VK_DELETE:
            strCode = "delete"; break;
        case 0x1E:
            strCode = "backspace"; break;
        case 0x01:
            strCode = "esc"; break;
        case VK_CAPITAL:
            strCode = "caps"; break;
        case VK_BACK:
            strCode = "back"; break;
        case 0xC4:
            strCode = "ä"; break;
        case 0xE4:
            strCode = "ä"; break;
        case 0xD4:
            strCode = "ö"; break;
        case 0xF4:
            strCode = "ö"; break;
        case 0xDC:
            strCode = "ü"; break;
        case 0xFC:
            strCode = "ü"; break;
        default:
            break;
        }
    }

    return strCode;
}
