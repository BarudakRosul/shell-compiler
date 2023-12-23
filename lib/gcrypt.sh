#!/bin/bash
#
# Author: FajarKim (Rangga Fajar Oktariansyah)
# GitHub: https://github.com/FajarKim
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I��D����k̅�LH}v�OP.�� �p1M�,�3T�S��`>� �^����RKuy0��!?�c}�6��[�|�,%�F�m�r�[ߠ��'�VG#�ϸ��H��x������O�
�&�F(+�R�f&8� F~�<�>��q݂.�x���'���B�f-'��پ֮�f�\d'�`ނ$��ߴ�j��H!�ҽx,�/m�˱e��M��/��A���Z��`�4H�3����/6H����eo=�7Ԝ,���jm�_��XB��HT�m��a�@F�@_@	Zo� z����dm��K`�g��5�ב���Y=�!�k�7k��X�W�$����B�h�BH�98�����f�,����u(��<�f�H��`LpЦ�yl�U�Ӹ��G��ޥ%�����)�"�[����0A�W��]���$�e哊��R{ai���ŉy,���}�B��נ�q������Y��3b�'W�� ��(s���S�خ�q~�n�O:�a��it^����Jn3�����2ؘNc��^,ܲ�-�'`,��z�����Z�����t9Z[7Pt?��Gf�{�J�47��Z��ws~R��YP�Y	�O Z��>�Z�zi��&�VM��ޯ� ��\�������8��)z�e�&�4���Hx���sw��x[�Z���<
��/�k�B�J�:;�y�g���a���Q�o�{"ăg�E��h��B�^�=uu�P�:Iy����fHUq��E���Ff	�ܶ!�����7f�lY�y�J\t.;��E|pסc㝝򎋻@�c����N���9J���X����9�|W�옪���f��*\\�f�b9�P_�#^m"��:`|G}0<�B���;�ztA�Kt�g.���9K��$e���F�R�T�C�+�^V�5��>����;/<DeQ
���Z���T���� �t��o��[Ѭ�A$�^N��`H&���j�`)�U�R��jۆr+��9{�!�y.�XW'A?���>y����Z�S3��#�7^�P%q��Ʒ�z� ��s<�S�f�����v ^��?�?�����+�~�h}�l��놂�+o*�T�=�^�yڼ�7D�儬D��)���#m���)s� I��Ș�5�g��F�a�@dH�my,��g�e=(���@����N.��k�<�L��U��lX��i2����_⠽���"ʩ�ݏ�&��"i��{f��������f�CQ��`�,lJ����ɃÒ'�X.:�Ml���u%�;%�1�L�=	XRz��Zȯ��t�����ц���`�~��D ]춧؟U����w���\8,�+��K(!Cwώ�u���N���Q���L:�B�z��)�nhOWsٿ4A�&Om�8���v�*��'n.y��!�p(]�ub���d�Xނ'(�-k���Ko)���TP��Xp�����:���' �ݹ�����ĥ;R�M���9&�C��s�����	���)������F���^רk��5L���l�ȉ�#�(�wn����'ũkg���J�319�\)�ԇC|B�R��J�p���ڹ,��;�b(d���e�~b`�l0�+r���%W�?�Y`�v����N�g2�=_m�����7�����O�z��������7CW��7�����;��Owi�	�ʟd�5�~���֡7�r��T�� CÊ� ��?������͟�EI;�j2/xu��OC��M�	���y��>��;�^Я�~���z4�l��Kz��Xg6����.� ��癀�[��^�`�.�<�Է?��j�R� ��w��B)Z��ʄI�?M#܆G�ϡ�ߴ�]���tU���ɪ���=s4��E�&�A��o�+6Z��\�tp�\��c��\�xGͭ��'�W?�؃�<����o��u��˖Eq^��>�r���̥�0â.���H�)=꬛�9_(�@�s�h��?J{��CY��5����!c*LC������|2;1�IKf����<�Em�Ṯ����9�.�=ĕwF;?$Lˁ֪`�}�y�
�R�ԁd(k���w��;+�i�bȔ]�(��Ӏ^���Yr�eG���5�6�t]L�6�Y�31#����*������� �ldJ��	_�18�n���Rsڅ;��WR���T�$z� ������N5��?^"�iS�F�M7��'o��47����jUVspo�d�ݬ��U�K��DZ�R�4Z<m��~����X(��}ς��{�d�_�dd�p�͹��n�U���9u�я&���6��7�K@f���8Rm9ǖ
A��]�/�=�,>��o�~��A��W������X�#_�Irh|��)�jM|�<! �����.ю�{��~���qz'p�6�I���AIX��r���'-��HbbIx�4��u	� �lL��5�c!6C�����[C�fA��>x���E�s[/��$A�V�T9$`袁�<���\U��R���p` ɃcZ�R����1;X�����������d�UU)�f�U��^�,�*��4g� 
>c��W=���L�W�Ц�N�p�+��b�]����|g��g���*�W�d�O&N�6u�O�%;����>�w~���5�:�=�Ƃ�l@!>O�,4!�X��]R�����x�t�������%�1�]I��Ueb̛@8=g�I�NЕ~���>�b7�sðz�y�LkN�p}Wp�S��?7������U����ER�?�}��6�Wt8U�k��\żl �燓@btVQi]��ո���M.U7�Gm��� �)l�J��3,�q`�q�C��T�'S�1���&.ʘ�]���V���S(�҂\ɟ?����7K*�}�
�(�j��RH��@���U�Tr(�	%,�S�V)G���j��ovQ8�8%��;F,t�늄8�oݧ���vݽk�*$TMU���d��,4�?�u���XM���#]/;m�b'���5[�}2������5�k�[\gT���ԛ�7�G�>d�������[br�M��b�L�%\�3�%�>o9���&�G�bs<���ME*2JrB�����Q�8�y���͡����6*�WĘ���J�j��w�2�h]�������Y�d�,�$���|>̫	�$rY�Q
:W��措�<�����P��>���4�o$
�!�q�q��04�{4���kf�)_��~���8��FS��7���ܧ�H��g)F����g@-��7��Y���/;�t��HM`�s��4��fd�iҮ��u��J�Hf0��D��Ɵ�Qm���09#��? O�\w�Xi@z�3h�s��x���grA�����A��93��;��8�0XR{/���f6����<���:H��o��V:�'�(����OMA?�v������E�$��'�ה�jV�jiuӜ�T��e�Z��Q�ߎU"�@�W���^O��P�I�ǹ���S�J���,��d�jG'��̊	;ڋ�<��+.�ٙ�h��:W�c���X�3����I����M�l,m5(l���顁	S�9Z="��z02��^��ͨ��&�,�ӑ1�183�����16�3hS��-��4%�Bǆ�^Z(:�ۚ�x�hlf���y&�I�c�o�����2����=���f�I�Q��D���λ��f|p�y�,�\��X^C�w�OI_JZ81Hh�d8��r�n���69G��(@����%�wI���\����W�ђL3��9��~p�nq�[��������/ &��?����^,n8m�!�>�fGY�c��^7>�0��'R�N��%Z���v�6ɒSjj�Y����h�p�����>� ����6��2�=d��xZ����f~���C��JP`�m�K= >�������U��-���s3\2l�jX!(�o~O�é����>s��S��K}&�`�/�c{�rBF�1�:u�q:.�Y�J|�6"<��=�LoVa���9C��ΰH2��q�ab��M�ӟ6ot���y���g�3zroԥ�O,�^��QCC��gxK��ݑ������#X�T�.5=�(�-�'̭rw��-�５>!�R	f�\�V�V�d�PD��]�Zyz9'qU=��{�L�!o]����Yx-�{nNd��?k�ON[78>&%��v�q�H�'��Nk<�l��c�)�`��ȺC��
���^E��e�iB��O=��	x�6�4�����C�43ˋ¦�p�����O�1l������쒑E�b�#�GH��=LKѠ(#����HWy�o�Ҭ@���9����6�=���S$L�O��s3:)3�ś�r�^ �`��e��$�!Zՙ�Yo4�7Ů�Fa�i�LE	%��9��P����?CɻF�E�((��ٌ=GQ=���n=���<F���{����Vj���N~�Q�X��ZX�k=�fmR��9ػ�Z1w�B�i~?�\T�D)Ǳ��[l`�-��ݛ|O����ә��x_J=�dFҢh��w
:Â�B���.pɘ� .���L-���/��3��ʚJ�QX&�i���EO���11y��,�pv��"/V;�H'V��~O��Y��R�QX9��D�d�	L�a��D_]��A#m����4Ëf�w��o�ɪǤdaSE�<Ժ[��������a*�9X�I�j�e:V�m:��}x���$��v3�{�L������V���D��գ$Yj %��%?C$�G�y8hO��/���yp���".^������b�oq����N3h��g�0:=U�=C����~$xNy��S4�Z�q���\��冒7��G�2
�`�Q3.�d
��]=އ��J�����ɔF������J���}��]����6����d�>(�;��s��2趢z�=$�(�i�x�~���B��VvB@�f3��{ۻM�Hs�#/CR(x�S�IB��4˕�֠�J�����	���޸��U�Q���L.�Oa!�[5�3T�Y�3c�z�7��ky��'f~2�G^�%&�mp����n���H�3�	������w[�'<����n�}<�רx�dKi�����c�g�:Ko'WY��"����ZN�����򝓷�4p;0X�/�莣�o0J�%\ZP^;Kd~�@�Z�ReV̓�@S-����H硠z�&B4=:��%�d81y%e����~���ء �&�$�rbE?m�,�f�Y0--B��u�ʖAc���+qJW������Z� ���rY�]���H
s���>ɠ�Tܭ NU֎�>�(>[����]^�ECh����